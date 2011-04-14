require 'sinatra/base'
require 'rack'

module Sinatra
  module Auth
    module Helpers
      def securityEnabled?
        options.respond_to?('securityEnabled') ? options.securityEnabled : true
      end

      def token_id
        session[:token_id] || env["HTTP_TOKEN"] || Auth::new_token_id
      end

      def token
        tokens[token_id]
      end

      def login!
        token = custom_auth::authenticate(token_id)
        error 404, 'Invalid username or password' unless token

        if expired?
          forget
          session[:token_id] = custom_auth::new_token_id
          remember token
        end

        Auth::get_response(token_id, token)
      end

      def authorize!
        return unless securityEnabled?
        error 401, "#{"<b>#{self.class}</b><br/>" if Sinatra::Base.development? || Sinatra::Base.test?}Not authenticated for #{request.path_info}" unless authorized?
      end

      def authorized?
        !recall.nil?
      end

      def logout!
        authorize!
        forget
      end

      def meta; (class << self; self; end); end
      def tokens; meta.class_variable_get :@@tokens end
      def custom_auth; options.auth end

      protected

      def remember(token)
        tokens[token_id] = recall unless tokens[token_id]
        tokens[token_id] = custom_auth::create_token(token_id, token) if tokens[token_id].nil? || expired?
        session[:token_id] = token_id
      end

      def forget
        unless tokens[token_id].nil?
          custom_auth::destroy_token(token_id)
          tokens[token_id] = nil
        end
      end

      def recall
        tokens[token_id] = custom_auth::get_token(token_id) if tokens[token_id].nil?
        expire! if expired?
        tokens[token_id]
      end

      def expired?
        !tokens[token_id].nil? && custom_auth::token_expired?(tokens[token_id])
      end

      def expire!
        tokens[token_id] = nil
        error 403, 'Token Expired'
      end
    end

    protected

    def self.registered(app)
      app.enable :sessions
      app.set :auth, Auth
      app.class_variable_set :@@tokens, Hash.new
      app.helpers Auth::Helpers
    end
  end
  register Auth
end
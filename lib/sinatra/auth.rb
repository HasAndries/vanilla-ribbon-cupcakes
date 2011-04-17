require 'sinatra/base'
require './lib/generate'

module Sinatra
  module Auth
    class Author
      public
      def new_token_id() Generate.random 24 end
      def authenticate(token_id, params) true end
      def create_token(token_id, params) tokens[token_id] = {:token_id => token_id, :username => params[:username], :expire_time => (Time.now+(14*24*60*60)).utc} end
      def get_token(token_id) tokens[token_id] end
      def token_expired?(token) Time.now.utc > token[:expire_time] end
      def destroy_token(token_id) tokens.delete token_id end
      private
      def tokens; (@@tokens ||= {}) end
    end

    module Helpers
      def securityEnabled?() options.respond_to?('securityEnabled') ? options.securityEnabled : true end
      def meta; (class << self; self; end); end

      def author; options.author end
      
      def tokens; meta.class_variable_get :@@tokens end
      def token_id()
        session[:token] || env["HTTP_TOKEN"] || params[:token] || author.new_token_id
      end
      def token() tokens[token_id] end

      def authorize!
        return unless securityEnabled?
        error 401, "#{"<b>#{self.class}</b><br/>" if Sinatra::Base.development? || Sinatra::Base.test?}Not authenticated for #{request.path_info}" unless authorized?
      end

      def authorized?
        authorized = !recall.nil?
        authorized
      end

      def login!
        session[:token] = token_id

        if author.authenticate(token_id, params)
          token = author.get_token(token_id)
          p token
          unless token && !token.empty?
            author.create_token(token_id, params)
            token = author.get_token(token_id)
          end
          p token
          tokens[token_id] = token
          forget! if expired?
        end
        error 404, 'Invalid username or password' unless tokens[token_id]

        tokens[token_id]
      end
      
      def logout!
        authorize!
        forget!
      end

      protected
      def recall
        tokens[token_id] = author.get_token(token_id) if tokens[token_id].nil?
        expire! if expired?
        tokens[token_id]
      end

      def expired?
        expired = !tokens[token_id].nil? && author.token_expired?(tokens[token_id])
        expired
      end

      def expire!
        forget!
        error 403, 'Token Expired'
      end
      def forget!
        if tokens.has_key? token_id
          author.destroy_token(token_id)
          tokens.delete token_id
          session.delete :token
        end
      end
    end

    protected
    def self.registered(app)
      app.enable :sessions
      app.set :author, Author.new
      app.class_variable_set :@@tokens, Hash.new
      app.helpers Auth::Helpers
    end
  end
  register Auth
end
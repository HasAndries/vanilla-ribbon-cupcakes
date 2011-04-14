require 'sinatra/base'
require 'rack'
require './lib/generate'

module Sinatra
  module Auth
    
    class Auther
      public
      def new_token_id() Generate.random 24 end
      def authenticate(token_id, params) {:token_id => token_id, :username => params[:username], :expire_time => (Time.now+(14*24*60*60)).utc} end
      def create_token(token_id, token) tokens[token_id] = token end
      def get_token(token_id) tokens[token_id] end
      def token_expired?(token) Time.now.utc > token[:expire_time] end
      def destroy_token(token_id) tokens.delete token_id end
      private
      def tokens; (@@tokens ||= {}) end
    end
    
    module Helpers
      def securityEnabled?() options.respond_to?('securityEnabled') ? options.securityEnabled : true end
      def meta; (class << self; self; end); end

      def auther; options.auther end
      
      def tokens; meta.class_variable_get :@@tokens end
      def token_id()
        session[:token] || env["HTTP_TOKEN"] || params[:token] || auther.new_token_id
      end
      def token() tokens[token_id] end

      def authorize!
        return unless securityEnabled?
        error 401, "#{"<b>#{self.class}</b><br/>" if Sinatra::Base.development? || Sinatra::Base.test?}Not authenticated for #{request.path_info}" unless authorized?
      end

      def authorized?
        authorized = !recall.nil?
        #puts "Authorized? (#{token_id}) - #{authorized}"
        authorized
      end

      def login!
        session[:token] = token_id
        
        #puts "Login! (#{token_id})"
        forget! if expired?
        tokens[token_id] = auther.authenticate(token_id, params)
        session[:token] = token_id
        #puts "Token (#{token_id}) - #{tokens[token_id]}"
        error 404, 'Invalid username or password' unless tokens[token_id]

        token
      end
      
      def logout!
        #puts "Logout! (#{token_id})"
        authorize!
        forget!
      end

      protected
      def recall
        #puts "Recall (#{token_id})"
        tokens[token_id] = auther.get_token(token_id) if tokens[token_id].nil?
        expire! if expired?
        tokens[token_id]
      end

      def expired?
        expired = !tokens[token_id].nil? && auther.token_expired?(tokens[token_id])
        #puts "Expired? (#{token_id}) - #{expired}"
        expired
      end

      def expire!
        #puts "Expire! (#{token_id})"
        forget!
        error 403, 'Token Expired'
      end
      def forget!
        #puts "Forget! (#{token_id})"
        if tokens.has_key? token_id
          auther.destroy_token(token_id)
          tokens.delete token_id
        end
      end
    end

    protected

    def self.registered(app)
      app.enable :sessions
      app.set :auther, Auther.new
      app.class_variable_set :@@tokens, Hash.new
      app.helpers Auth::Helpers
    end
  end
  register Auth
end
require './lib/dio/auth'
require './lib/generate'

module Auth
  class << self

    def new_token_id
      Generate.random 24
    end

    def authenticate(token_id)
      user = AUTH.get_user params[:username]
      token = get_token token_id
      token_match = (token && token[:token_id] == token_id) || token.nil?
      {:token_id => token_id, :username => username, :expire_time => Time.now.utc} if user && user.password && token_match
    end

    def get_token(token_id)
      AUTH.get_token token_id
    end
    
    def create_token(token_id, token)
      AUTH.create_token token_id, token[:username], token[:expire_time]
    end

    def destroy_token(token_id)
      AUTH.destroy_token token_id
    end

    def token_expired?(token)
      Time.now.utc > token[:expire_time]
    end
  end
end
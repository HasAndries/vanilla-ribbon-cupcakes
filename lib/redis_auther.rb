require './lib/dio/auth'
require './lib/sinatra/auth'

class RedisAuther < Sinatra::Auth::Auther
  def authenticate(token_id, params)
    user = AUTH.get_user params[:username]
    p user, user && user.password && token_match
    token = get_token token_id
    token_match = (token && token[:token_id] == token_id) || token.nil?
    {:token_id => token_id, :username => username, :expire_time => (Time.now+(14*24*60*60)).utc} if user && user.password && token_match
  end

  def create_token(token_id, token)
    AUTH.create_token token_id, token[:username], token[:expire_time]
  end
  def get_token(token_id)
    AUTH.get_token token_id
  end

  def token_expired?(token)
    Time.now.utc > token[:expire_time]
  end

  def destroy_token(token_id)
    AUTH.destroy_token token_id
  end
end
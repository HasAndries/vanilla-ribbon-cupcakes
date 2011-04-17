require './app/settings'
require './app/dat/auth'
require './lib/sinatra/auth'

class RedisAuthor < Sinatra::Auth::Author
  def expire_seconds() Settings.environment[:expire_days]*24*60*60 end

  def authenticate(token_id, params)
    user = Dat::Auth.get_user params[:username]
    password_match = params[:password] == user[:password]
    token = get_token token_id
    token_match = token[:token_id] == token_id || token.empty?
    password_match && token_match
  end

  def create_token(token_id, params)
    Dat::Auth.create_token(token_id, params[:username], (Time.now+(expire_seconds)).utc)
  end
  def get_token(token_id)
    Dat::Auth.get_token token_id
  end

  def token_expired?(token)
    token[:expire_time] && Time.parse(token[:expire_time]) < Time.now.utc
  end

  def destroy_token(token_id)
    Dat::Auth.destroy_token token_id
  end
end
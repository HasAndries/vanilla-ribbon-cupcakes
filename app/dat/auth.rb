require 'redis'
require './lib/to_sym'
require './app/settings'

DB ||= Redis.connect(Settings.database)

module Dat
  class Auth
      class << self
        def get_user(username)
          DB.hgetall("user:#{username}").to_sym
        end

        def get_token(token_id)
          DB.hgetall("token:#{token_id}").to_sym
        end

        def create_token(token_id, username, expire_time)
          DB.hset "token:#{token_id}", "user", "user:#{username}"
          DB.hset "token:#{token_id}", "expire_time", expire_time
        end

        def destroy_token(token_id)
          DB.del "token:#{token_id}"
        end
      end
  end
end


require 'redis'
require './lib/to_sym'
require './lib/settings'

REDIS ||= Redis.connect(Settings.db)

module DIO
  class Auth

      def get_user(username)
        REDIS.hgetall("user:#{username}").to_sym
      end

      def get_token(token_id)
        REDIS.hgetall("token:#{token_id}").to_sym
      end

      def create_token(token_id, username, expire_time)
        REDIS.hset "token:#{token_id}", "user", "user:#{username}"
        REDIS.hset "token:#{token_id}", "expire_time", expire_time
      end

      def destroy_token(token_id)
        REDIS.del "token:#{token_id}"
      end
      
  end
end

AUTH = DIO::Auth.new
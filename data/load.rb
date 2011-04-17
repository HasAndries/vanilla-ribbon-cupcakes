require './app/settings'
require 'redis'

REDIS ||= Redis.connect(Settings.db)

def load_user(username, password)
  REDIS.hmset "user:#{username}", :password, password
  REDIS.sadd "users", "user:#{username}"
end
def load_product(id, name)
  REDIS.hmset "product:#{id}", :name, name
  REDIS.sadd "products", "product:#{id}"
end

require './lib/settings'
require 'redis'

REDIS ||= Redis.connect(Settings.db)

def load_product(id, name)
  REDIS.hmset "product:#{id}", :name, name
  REDIS.sadd "products", "product:#{id}"
end
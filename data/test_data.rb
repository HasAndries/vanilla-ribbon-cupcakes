require './lib/settings'
require 'redis'

REDIS ||= Redis.connect(Settings.db)

def load_product(id, name)
  REDIS.hmset "product:#{id}", :name, name
  REDIS.sadd "products", "product:#{id}"
end
load_product 1, 'Plain Vanilla Cupcake'
load_product 2, 'Plain Chocolate Cupcake'
load_product 3, 'Vanilla Cupcake with Caramel filling'

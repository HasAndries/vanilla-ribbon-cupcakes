require 'redis'
require './lib/to_sym'
require './lib/settings'

REDIS ||= Redis.connect(Settings.db)

module DIO
  class Product
    def get_all()
      REDIS.smembers("products").collect do |product|
        REDIS.hgetall product
      end.to_sym
    end
  end
end

PRODUCTS = DIO::Product.new
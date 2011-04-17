require 'redis'
require './lib/to_sym'
require './app/settings'

DB ||= Redis.connect(Settings.database)

module Dat
  class Product
    class << self

      def get_all()
        DB.smembers("products").collect do |product|
          DB.hgetall product
        end.to_sym
      end
      
    end
  end
end

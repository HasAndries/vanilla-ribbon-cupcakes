require 'json'
require 'sinatra/base'

require './app/dat/product'

module Resource
  class Product < Sinatra::Base
    get '/product/?' do
      {
          :items => Dat::Product.get_all
      }.to_json
    end
  end
end
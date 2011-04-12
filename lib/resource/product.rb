require 'json'
require 'sinatra/base'

require './lib/dio/product'

module Resource
  class Product < Sinatra::Base
    get '/?' do
      {
          :items => PRODUCTS.get_all
      }.to_json
    end
  end
end
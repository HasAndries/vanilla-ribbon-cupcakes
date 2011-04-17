require 'sinatra/base'
require './app/redis_author'
require './app/resources/admin'
require './app/resources/update'
require './app/resources/product'

Sinatra::Base.register Sinatra::Auth
Sinatra::Base.set :author, RedisAuthor.new

class VanillaRibbon < Sinatra::Base
  use Resource::Admin
  use Resource::Product
  use Resource::Update
end
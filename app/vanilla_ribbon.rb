require 'sinatra/base'
require './app/redis_author'
require './app/resources/admin'
require './app/resources/update'

Sinatra::Base.register Sinatra::Auth
Sinatra::Base.set :author, RedisAuthor.new

class VanillaRibbon < Sinatra::Base
  use Resource::Admin
  use Resource::Update

  get '/?' do
    @name = 'index'
    erb :index
  end

  %w[specials menu contact about].each do |path|
      get "/#{path}/?" do
        @name = path
        erb path.to_sym
      end
    end
end
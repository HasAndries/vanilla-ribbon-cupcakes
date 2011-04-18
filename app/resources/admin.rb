require 'json'
require 'sinatra/base'
require './lib/sinatra/auth'

module Resource
  class Admin < Sinatra::Base
    
    before /^\/admin/ do
      is_login_url = (request.path_info =~ /^\/admin\/login/) == 0
      redirect '/admin/login' unless is_login_url || authorized?
    end

    get '/admin/?' do
      @name = 'index'
      erb :'admin/index', {:layout => :'admin/layout'}
    end

    %w[login products settings].each do |path|
      get "/admin/#{path}/?" do
        @name = path
        erb :"admin/#{path}", {:layout => :'admin/layout'}
      end
    end

    post '/admin/login' do
      login!.to_json
    end
    post '/admin/logout' do
      logout!.to_json
    end

  end
end
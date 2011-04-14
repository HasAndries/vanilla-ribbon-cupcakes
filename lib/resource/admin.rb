require 'json'
require 'sinatra/base'
require './lib/sinatra/auth'

module Resource
  class Admin < Sinatra::Base
    register Sinatra::Auth


    before /^\/admin/ do
      login_url = (request.path_info =~ /^\/admin\/login/) == 0
      redirect "/admin/login" unless login_url || authorized?
    end
    
    post '/admin/login' do
      login!.to_json
    end
  end
end
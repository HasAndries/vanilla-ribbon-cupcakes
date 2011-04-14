require 'sinatra/base'
require './lib/sinatra/auth'

module Resource
  class Admin < Sinatra::Base
    register Sinatra::Auth

    post '/admin/login' do
      if params[:username] == options.username && params[:password] == options.password
        session[:authorized] = true
        redirect "/admin/"
      else
        session[:authorized] = false
        redirect "/admin/login"
      end
    end

    get /^\/admin/ do
      login_url = (request.path_info =~ /^\/admin\/login/) == 0
      redirect "/admin/login" unless login_url || authorized?
      pass
    end
  end
end
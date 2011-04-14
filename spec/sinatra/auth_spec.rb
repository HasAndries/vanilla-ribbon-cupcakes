require 'rack/mock'
require 'sinatra/base'

require_relative '../spec_helper'
require './lib/sinatra/auth'
require './lib/redis_auth'

class AuthTest < Sinatra::Base
  register Sinatra::Auth
  set :auth, Module::new(Auth::Redis)

  get '/open' do p meta.class_variable_get :@@tokens; 'data' end
  get '/closed' do authorize!; 'data' end
  post '/login' do login! end
  post '/logout' do logout! end
end

describe Sinatra::Auth do

  it "should be able to use open routes" do
    env = Rack::MockRequest.env_for("/open")
    status, header, body = AuthTest.new.call(env)
    status.should == 200
  end

  it "should not be able to use closed routes" do
    env = Rack::MockRequest.env_for("/closed")
    status, header, body = AuthTest.new.call(env)
    status.should == 403
  end

end
require 'rack/mock'
require 'sinatra/base'

require_relative '../spec_helper'
require './lib/sinatra/auth'

def auther
  (@@auther = Sinatra::Auth::Auther.new)
end

describe Sinatra::Auth::Auther, "#new_token_id" do
  it "should generate a new token id" do
    s = auther.new_token_id
    s.should_not == auther.new_token_id
  end
end
describe Sinatra::Auth::Auther, "#authenticate" do
  it "should provide a token for the given params" do
    token = auther.authenticate 'abcd', {:username => 'admin'}
    token[:token_id].should == 'abcd'
    token[:username].should == 'admin'
    token.has_key?(:expire_time).should == true
  end
end
describe Sinatra::Auth::Auther, "#create_token" do
  it "should create a token for the given params" do
    token = auther.create_token 'abcd', {:token_id => 'abcd', :username => 'admin', :expire_time => (Time.now+(14*24*60*60)).utc}
    token[:token_id].should == 'abcd'
    token[:username].should == 'admin'
    token.has_key?(:expire_time).should == true
    auther.send(:tokens).has_key?('abcd').should == true
  end
end
describe Sinatra::Auth::Auther, "#get_token" do
  it "should get an already created token for the given params" do
    token = auther.get_token 'abcd'
    token[:token_id].should == 'abcd'
    token[:username].should == 'admin'
    token.has_key?(:expire_time).should == true
  end
end
describe Sinatra::Auth::Auther, "#token_expired?" do
  it "should determine if a token has expired" do
    auther.token_expired?(auther.send(:tokens)['abcd']).should == false
    auther.create_token 'abcd', {:token_id => 'abcd', :username => 'admin', :expire_time => (Time.now-1).utc}
    auther.token_expired?(auther.send(:tokens)['abcd']).should == true
  end
end
describe Sinatra::Auth::Auther, "#destroy_token" do
  it "should destroy an already created token for the given params" do
    auther.destroy_token 'abcd'
    auther.send(:tokens).has_key?('abcd').should == false
  end
end

class AuthTest < Sinatra::Base
  register Sinatra::Auth

  get '/open' do 'data' end
  get '/closed' do authorize!; 'data' end
  post '/login' do login! end
  post '/logout' do logout! end
end

def app
  (@app ||= AuthTest.new)
end

describe Sinatra::Auth do

  it "should be able to use open routes" do
    env = Rack::MockRequest.env_for("/open")
    status, header, body = app.call(env)
    status.should == 200
  end

  it "should not be able to use closed routes" do
    env = Rack::MockRequest.env_for("/closed")
    status, header, body = app.call(env)
    status.should == 401
  end

  it "should be able to login" do
    env = Rack::MockRequest.env_for("/login?token=123&username=admin", :method => 'POST')
    status, header, body = app.call(env)
    status.should == 200
    body[:username].should == 'admin'
    body.has_key?(:token_id).should == true
    body.has_key?(:expire_time).should == true
  end

  it "should be able to use open routes" do
    env = Rack::MockRequest.env_for("/open?token=123")
    status, header, body = app.call(env)
    status.should == 200
  end
  it "should be able to use closed routes" do
    env = Rack::MockRequest.env_for("/closed?token=123")
    status, header, body = app.call(env)
    status.should == 200
  end

end
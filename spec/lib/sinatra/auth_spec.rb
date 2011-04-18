require 'rack/mock'

require_relative '../../spec_helper'
require './lib/sinatra/auth'

def author
  (@@author = Sinatra::Auth::Author.new)
end

describe Sinatra::Auth::Author, "#new_token_id" do
  it "should generate a new token id" do
    s = author.new_token_id
    s.should_not == author.new_token_id
  end
end
describe Sinatra::Auth::Author, "#authenticate" do
  it "should provide a token for the given params" do
    author.authenticate('abcd', {:username => 'admin'}).should == true
  end
end
describe Sinatra::Auth::Author, "#create_token" do
  it "should create a token for the given params" do
    token = author.create_token 'abcd', {:token_id => 'abcd', :username => 'admin', :expire_time => (Time.now+(14*24*60*60)).utc}
    token[:token_id].should == 'abcd'
    token[:username].should == 'admin'
    token.has_key?(:expire_time).should == true
    author.send(:tokens).has_key?('abcd').should == true
  end
end
describe Sinatra::Auth::Author, "#get_token" do
  it "should get an already created token for the given params" do
    token = author.get_token 'abcd'
    token[:token_id].should == 'abcd'
    token[:username].should == 'admin'
    token.has_key?(:expire_time).should == true
  end
end
describe Sinatra::Auth::Author, "#token_expired?" do
  it "should determine if a token has expired" do
    author.token_expired?(author.send(:tokens)['abcd']).should == false
    author.create_token 'abcd', {:token_id => 'abcd', :username => 'admin', :expire_time => (Time.now-1).utc}
    author.token_expired?(author.send(:tokens)['abcd']).should == true
  end
end
describe Sinatra::Auth::Author, "#destroy_token" do
  it "should destroy an already created token for the given params" do
    author.destroy_token 'abcd'
    author.send(:tokens).has_key?('abcd').should == false
  end
end

class AuthTest < Sinatra::Base
  register Sinatra::Auth

  get '/open' do 'dat' end
  get '/closed' do authorize!; 'dat' end
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
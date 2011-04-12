require 'rack/mock'

require_relative '../spec_helper'
require './lib/resource/product'

describe Resource::Product, "#/?" do

  it "should get all products" do

    env = Rack::MockRequest.env_for("/")
    status, header, body = Resource::Product.new.call(env)
    status.should == 200
    data = JSON.parse(body[0]).to_sym
    data[:items][0].should == {:name => 'Plain Vanilla Cupcake'}
  end

end
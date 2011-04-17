require_relative '../../spec_helper'
require './app/dat/product'

describe Dat::Product, "#get_all" do

  it "should get all products" do

    data = Dat::Product.get_all
    data.empty?.should == false
    data[0].should == {:name => 'Plain Vanilla Cupcake'}
  end

end
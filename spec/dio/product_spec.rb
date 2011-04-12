require_relative '../spec_helper'
require './lib/dio/product'

describe DIO::Product, "#get_all" do

  it "should get all products" do

    data = PRODUCTS.get_all
    data.empty?.should == false
    data[0].should == {:name => 'Plain Vanilla Cupcake'}
  end

end
require "../../spec_helper"

describe Algo::Backtester::OrderBook do
  it "should add an order to an empty orderbook" do
    ob = Algo::Backtester::OrderBook.new
    ob.size.should eq(0)
    ob.add create_order()
    ob.size.should eq(1)
  end

  it "should add an order to an existing orderbook" do
    ob = Algo::Backtester::OrderBook.new
    ob.size.should eq(0)
    ob.add create_order()
    ob.add create_order()
    ob.size.should eq(2)
  end

  it "should not remove an order from an empty orderbook" do
    ob = Algo::Backtester::OrderBook.new
    ob.remove(1).should be_false
  end

  it "should remove an existing order from an orderbook" do
    ob = Algo::Backtester::OrderBook.new
    ob.add create_order()
    ob.remove(0).should be_true
  end

  it "should remove multiple existing orders from an orderbook" do
    ob = Algo::Backtester::OrderBook.new
    ob.add create_order()
    ob.add create_order()
    ob.remove(0).should be_true
    ob.remove(1).should be_true
  end
end

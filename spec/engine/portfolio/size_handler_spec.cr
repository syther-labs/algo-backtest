require "../../spec_helper"

describe Algo::Backtester::SizeHandler do
  describe "#size_order" do
    it "should size a BUY order" do
      p = create_portfolio
      o = create_order({quantity: 0_i64, direction: Algo::Backtester::Direction::BGHT})
      b = create_bar({close: 1.0_f64})
      sized = create_order_sizer().size_order(order: o, bar: b, portfolio: p)
      sized.quantity.should eq(100)
    end

    it "should size a SELL order" do
      p = create_portfolio
      o = create_order({quantity: 0_i64, direction: Algo::Backtester::Direction::SOLD})
      b = create_bar({close: 1.0_f64})
      sized = create_order_sizer().size_order(order: o, bar: b, portfolio: p)
      sized.quantity.should eq(100)
    end

    it "should throw exception when no order to exit from" do
      p = create_portfolio
      o = create_order({quantity: 0_i64, direction: Algo::Backtester::Direction::EXIT})
      b = create_bar({close: 1.0_f64})
      expect_raises Exception do
        create_order_sizer().size_order(order: o, bar: b, portfolio: p)
      end
    end

    pending "should exit from a long position" do
    end

    pending "should exit from a short position" do
    end
  end

  describe "##set_default_size" do
    it "should change quantity when price is higher than default_value" do
      p = create_portfolio
      o = create_order({quantity: 15_i64, direction: Algo::Backtester::Direction::BGHT})
      b = create_bar({close: 15.0_f64})
      sized = create_order_sizer().size_order(order: o, bar: b, portfolio: p)
      sized.quantity.should eq(66)
    end

    it "should change quantity when price is lower than default_value" do
      p = create_portfolio
      o = create_order({quantity: 15_i64, direction: Algo::Backtester::Direction::BGHT})
      b = create_bar({close: 8.0_f64})
      sized = create_order_sizer().size_order(order: o, bar: b, portfolio: p)
      sized.quantity.should eq(100)
    end
  end
end

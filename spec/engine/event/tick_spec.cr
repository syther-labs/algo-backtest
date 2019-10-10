require "../../spec_helper"

def create_task
  dir = Algo::Backtester::Direction::EXIT
  oe = Algo::Backtester::SignalEvent.new(timestamp: Time.now, symbol: "ACME", direction: dir)
  m = Algo::Backtester::Metric.new
  t = Algo::Backtester::Tick.new(oe, m, 80.0, 100.0, 1000.0, 1000.0)
  return t
end

describe Algo::Backtester::Tick do
  it "is created properly" do
    t = create_task
    t.should_not be_nil
  end

  it "calculates spread correctly" do
    t = create_task
    expected = 20
    t.spread.should eq(expected)
  end

  it "calculates price correctly" do
    t = create_task
    expected = (80 + 100) / 2.0
    t.price.should eq(expected)
  end
end

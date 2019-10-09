require "../../spec_helper"
require "../../../src/engine/event/bar.cr"
require "../../../src/engine/event/data_handler.cr"
require "json"

def create_bar
  Algo::Backtester::Bar.new(timestamp: Time.now, symbol: "AAPL", adj_close: 224.4_f32,
    adj_high: 228.06_f32, adj_low: 224.33_f32, adj_open: 225.82_f32,
    adj_volume: 29282700, close: 224.4_f32, div_cash: 0.0_f32, high: 228.06_f32,
    low: 224.33_f32, split_factor: 1.0_f32, volume: 29282700)
end

describe Algo::Backtester::DataHandler do
  describe "#reset" do
    it "should reset with empty data stream" do
      dh = Algo::Backtester::DataHandler.new
      dh.stream = [create_bar] of Algo::Backtester::Bar
      dh.history = [create_bar] of Algo::Backtester::Bar
      dh.update_latest(create_bar)
      dh.reset!
      dh.stream.empty?.should be_false
      dh.latest("AAPL").should be_nil
      dh.list("AAPL").should be_nil
      dh.history.empty?.should be_true
    end

    it "should reset with empty data" do
      dh = Algo::Backtester::DataHandler.new
      dh.reset!
      dh.stream.empty?.should be_true
      dh.latest("AAPL").should be_nil
      dh.list("AAPL").should be_nil
      dh.history.empty?.should be_true
    end
  end

  describe "#next" do
    it "should add a single event to history" do
      dh = Algo::Backtester::DataHandler.new
      dh.stream = [create_bar, create_bar, create_bar] of Algo::Backtester::Bar
      dh.history = [] of Algo::Backtester::Bar
      dh.update_latest(create_bar)
      dh.update_list(create_bar)

      dh.stream.empty?.should be_false
      dh.history.empty?.should be_true

      dh.next!.should be_true

      dh.history.size.should eq(1)
    end

    it "should add the multiple events to history" do
      dh = Algo::Backtester::DataHandler.new
      dh.stream = [create_bar, create_bar, create_bar] of Algo::Backtester::Bar
      dh.history = [] of Algo::Backtester::Bar
      dh.update_latest(create_bar)
      dh.update_list(create_bar)

      dh.stream.empty?.should be_false
      dh.history.empty?.should be_true

      dh.next!.should be_true
      dh.next!.should be_true

      dh.history.size.should eq(2)
    end

    it "should fail when no events are provided" do
      dh = Algo::Backtester::DataHandler.new
      dh.next!.should be_false
      dh.history.empty?.should be_true
    end
  end

  describe "#update_latest" do
    it "should update empty latest" do
      dh = Algo::Backtester::DataHandler.new
      dh.latest("AAPL").should be_nil
      dh.update_latest(create_bar)
      dh.latest("AAPL").should_not be_nil
    end

    it "should update filled latest" do
      dh = Algo::Backtester::DataHandler.new
      dh.stream = [create_bar, create_bar, create_bar] of Algo::Backtester::Bar

      old_date = 3.days.ago
      new_date = Time.now

      old_bar = create_bar()
      old_bar.timestamp = old_date

      new_bar = create_bar()
      new_bar.timestamp = new_date

      dh.update_latest(old_bar)
      dh.latest("AAPL").try {|t| t.timestamp.should eq(old_date) }

      # Should replace old bar with new bar
      dh.update_latest(new_bar)
      dh.latest("AAPL").try {|t| t.timestamp.should eq(new_date) }
    end
  end

  describe "#update_list" do
    it "should update empty list" do
      dh = Algo::Backtester::DataHandler.new
      dh.list("AAPL").should be_nil
      dh.update_list(create_bar)
      dh.list("AAPL").should_not be_nil
    end

    it "should update filled list" do
      dh = Algo::Backtester::DataHandler.new
      dh.stream = [create_bar, create_bar, create_bar] of Algo::Backtester::Bar

      old_date = 3.days.ago
      new_date = Time.now

      old_bar = create_bar()
      old_bar.timestamp = old_date

      new_bar = create_bar()
      new_bar.timestamp = new_date

      dh.update_list(old_bar)
      dh.list("AAPL").try { |tArr| tArr.last.timestamp.should eq(old_date) }

      # Should replace old bar with new bar
      dh.update_list(new_bar)
      dh.list("AAPL").try { |tArr| tArr.last.timestamp.should eq(new_date) }
    end
  end
end

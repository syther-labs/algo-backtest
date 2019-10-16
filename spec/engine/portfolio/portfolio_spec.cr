require "../../spec_helper"

describe AlgoBacktester::Portfolio do
  describe "#reset" do
    it "should reset a full portfolio" do
      port = create_portfolio

      # Add a holding.
      dh = AlgoBacktester::DataHandler.new
      port.on_fill(create_fill, dh)
      port.holdings.empty?.should be_false

      port.reset!
      port.holdings.empty?.should be_true
    end

    it "should reset an empty portfolio" do
      port = create_portfolio
      port.reset!
      port.holdings.empty?.should be_true
    end
  end
  describe "#on_signal" do
    it "should return a sized order from a fill that has an existing bar" do
      dh = AlgoBacktester::DataHandler.new
      dh.stream = [create_bar({symbol: "AAPL"})]
      dh.next!

      signal = AlgoBacktester::SignalEvent.new(
        symbol: "AAPL",
        direction: AlgoBacktester::Direction::Buy,
        timestamp: 1.day.ago
      )
      port = create_portfolio
      fill = port.on_signal(signal, dh)

      fill.symbol.should eq(signal.symbol)
      fill.timestamp.should eq(signal.timestamp)
      fill.direction.should eq(signal.direction)
      fill.quantity.should be > 1
    end
    it "should fail when handling a signal with no data" do
      dh = AlgoBacktester::DataHandler.new

      signal = AlgoBacktester::SignalEvent.new(
        symbol: "AAPL",
        direction: AlgoBacktester::Direction::Buy,
        timestamp: 1.day.ago
      )
      port = create_portfolio
      expect_raises(Exception) do
        fill = port.on_signal(signal, dh)
      end
    end
  end

  describe "#is_invested" do
    it "should return nil with an empty portfolio" do
      port = create_portfolio
      actual = port.is_invested("AAPL")
      actual.should be_nil
    end
    it "should return position with a long position" do
      port = create_portfolio
      # Add a holding.
      dh = AlgoBacktester::DataHandler.new
      fill = create_fill({direction: AlgoBacktester::Direction::Buy})
      port.on_fill(fill, dh)
      actual = port.is_invested("AAPL")
      actual.should_not be_nil
      actual.try { |a| a.symbol.should eq("AAPL") }
    end

    it "should return position with a short position" do
      port = create_portfolio
      # Add a holding.
      dh = AlgoBacktester::DataHandler.new
      fill = create_fill({direction: AlgoBacktester::Direction::Sell})
      port.on_fill(fill, dh)
      actual = port.is_invested("AAPL")
      actual.should_not be_nil
      actual.try { |a| a.symbol.should eq("AAPL") }
    end

    it "should return nil when not invested" do
      port = create_portfolio
      # Add a holding.
      dh = AlgoBacktester::DataHandler.new
      fill = create_fill({direction: AlgoBacktester::Direction::Buy})
      port.on_fill(fill, dh)
      actual = port.is_invested("NOT_AAPL")
      actual.should be_nil
    end
  end

  describe "#is_long" do
    it "should return nil with an empty portfolio" do
      port = create_portfolio
      actual = port.is_long("AAPL")
      actual.should be_nil
    end
    it "should return position with a long position" do
      port = create_portfolio
      # Add a holding.
      dh = AlgoBacktester::DataHandler.new
      fill = create_fill({direction: AlgoBacktester::Direction::Buy})
      port.on_fill(fill, dh)
      actual = port.is_long("AAPL")
      actual.should_not be_nil
      actual.try { |a| a.symbol.should eq("AAPL") }
    end

    it "should return nil with a short position" do
      port = create_portfolio
      # Add a holding.
      dh = AlgoBacktester::DataHandler.new
      fill = create_fill({direction: AlgoBacktester::Direction::Sell})
      port.on_fill(fill, dh)
      actual = port.is_long("AAPL")
      actual.should be_nil
    end

    it "should return nil when not invested" do
      port = create_portfolio
      # Add a holding.
      dh = AlgoBacktester::DataHandler.new
      fill = create_fill({direction: AlgoBacktester::Direction::Buy})
      port.on_fill(fill, dh)
      actual = port.is_long("NOT_AAPL")
      actual.should be_nil
    end
  end

  describe "#is_short" do
    it "should return nil with an empty portfolio" do
      port = create_portfolio
      actual = port.is_short("AAPL")
      actual.should be_nil
    end
    it "should return nil with a long position" do
      port = create_portfolio
      # Add a holding.
      dh = AlgoBacktester::DataHandler.new
      fill = create_fill({direction: AlgoBacktester::Direction::Buy})
      port.on_fill(fill, dh)
      actual = port.is_short("AAPL")
      actual.should be_nil
    end

    it "should return a position with a short position" do
      port = create_portfolio
      # Add a holding.
      dh = AlgoBacktester::DataHandler.new
      fill = create_fill({direction: AlgoBacktester::Direction::Sell})
      port.on_fill(fill, dh)
      actual = port.is_short("AAPL")
      actual.should_not be_nil
      actual.try { |a| a.symbol.should eq("AAPL") }
    end

    it "should return nil when not invested" do
      port = create_portfolio
      # Add a holding.
      dh = AlgoBacktester::DataHandler.new
      fill = create_fill({direction: AlgoBacktester::Direction::Buy})
      port.on_fill(fill, dh)
      actual = port.is_short("NOT_AAPL")
      actual.should be_nil
    end
  end

  describe "#value" do
    it "should return value with holdings and initial cash" do
      q = 1_i64
      port = create_portfolio(initial_cash: 1_000)
      # # Add a holding.
      dh = AlgoBacktester::DataHandler.new
      fills = [create_fill({symbol: "AAPL", quantity: q, price: 200_f64}),
               create_fill({symbol: "BANANA", quantity: q, price: 300_f64}),
               create_fill({symbol: "CHERRY", quantity: q, price: 500_f64}),
      ]
      fills.each { |f| port.on_fill(f, dh) }

      port.value.should eq 1_000.0
    end
    it "should return value without holdings but with initial cash" do
      q = 1_i64
      port = create_portfolio(initial_cash: 1_000)

      port.value.should eq 1_000.0
    end
  end
end

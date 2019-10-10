require "spec"
require "../src/**"

def create_bar(args : NamedTuple? = nil)
  kDefaultArgs = {timestamp: Time.now, symbol: "AAPL", adj_close: 224.4_f64,
                  adj_high: 228.06_f64, adj_low: 224.33_f64, adj_open: 225.82_f64,
                  adj_volume: 29282700_i64, close: 224.4_f64, div_cash: 0.0_f64, high: 228.06_f64,
                  low: 224.33_f64, split_factor: 1.0_f64, volume: 29282700_i64}

  if args.nil?
    Algo::Backtester::Bar.new(**kDefaultArgs)
  else
    Algo::Backtester::Bar.new(**kDefaultArgs.merge(args))
  end
end

def create_order(args : NamedTuple? = nil)
  kDefaultArgs = {
    id:              1_i64,
    symbol:          "ACME",
    timestamp:       Time.now,
    order_type:      Algo::Backtester::OrderType::Market,
    direction:       Algo::Backtester::Direction::EXIT,
    status:          Algo::Backtester::OrderStatus::None,
    asset_type:      "Gold",
    quantity:        1_i64,
    quantity_filled: 1_i64,
    limit_price:     1.0,
    stop_price:      1.0,
  }
  if args.nil?
    Algo::Backtester::OrderEvent.new(**kDefaultArgs)
  else
    Algo::Backtester::OrderEvent.new(**kDefaultArgs.merge(args))
  end
end

def create_order_sizer
  Algo::Backtester::SizeHandler.new(default_size: 100_i64, default_value: 1000_f64)
end

def create_portfolio
  Algo::Backtester::Portfolio.new(100_f64)
end

require "spec"

ENV["IS_SPEC"] = "true"

# Require manually to exclude the main file.
require "../src/data_downloader/**"
require "../src/engine/backtest/**"
require "../src/engine/event/**"
require "../src/engine/exchange/**"
require "../src/engine/tree/**"
require "../src/engine/portfolio/**"
require "../src/util/**"

include AlgoBacktester::DataDownloader
include AlgoBacktester::Event
include AlgoBacktester::Tree
include AlgoBacktester::StockExchange

alias AB = AlgoBacktester
alias DD = AB::DataDownloader
alias E = AB::Event
alias T = AB::Tree
alias SE = AB::StockExchange

def create_bar(args : NamedTuple? = nil)
  kDefaultArgs = {timestamp: Time.local, symbol: "AAPL", adj_close: 224.4_f64,
                  adj_high: 228.06_f64, adj_low: 224.33_f64, adj_open: 225.82_f64,
                  open: 225.82_f64, adj_volume: 29282700_i64, close: 224.4_f64,
                  div_cash: 0.0_f64, high: 228.06_f64, low: 224.33_f64, split_factor: 1.0_f64, volume: 29282700_i64}

  if args.nil?
    AB::Event::Bar.new(**kDefaultArgs)
  else
    AB::Event::Bar.new(**kDefaultArgs.merge(args))
  end
end

def create_order(args : NamedTuple? = nil)
  kDefaultArgs = {
    id:              1_i64,
    symbol:          "AAPL",
    timestamp:       Time.local,
    type:            AB::Event::OrderType::Market,
    direction:       AB::Event::Direction::Exit,
    status:          AB::Event::OrderStatus::Open,
    asset_type:      "Gold",
    quantity:        1_i64,
    quantity_filled: 1_i64,
    limit_price:     1.0,
    stop_price:      1.0,
  }
  if args.nil?
    AB::Event::OrderEvent.new(**kDefaultArgs)
  else
    AB::Event::OrderEvent.new(**kDefaultArgs.merge(args))
  end
end

def create_order_sizer
  AB::SizeHandler.new(default_size: 100_i64, default_value: 1000_f64)
end

def create_portfolio(initial_cash : Float64 = 1000_f64)
  AB::Portfolio.new(initial_cash)
end

def create_fill(args : NamedTuple? = nil)
  kDefaultArgs = {
    timestamp:    Time.local,
    symbol:       "AAPL",
    direction:    AB::Event::Direction::Buy,
    quantity:     10_i64,
    price:        100.0_f64,
    commission:   0_f64,
    exchange_fee: 0_f64,
  }
  if args.nil?
    AB::Event::FillEvent.new(**kDefaultArgs)
  else
    AB::Event::FillEvent.new(**kDefaultArgs.merge(args))
  end
end

def create_strat
  Strategy.new("this-is-a-test")
end

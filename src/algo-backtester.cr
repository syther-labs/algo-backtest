require "./**"
require "vcr"

# # @strategy.on_data() create signals
# # @portfolio.on_signal() returns an order
# # @exchange.on_order() returns a fill
# # a fill is then tracked by statistics handler

# # TODO: Write documentation for `AlgoBacktester`
module AlgoBacktester
  include AlgoBacktester::DataDownloader
  include AlgoBacktester::Event
  include AlgoBacktester::Tree
  include AlgoBacktester::StockExchange
  
  VERSION = "0.1.0"

  bars = [] of Bar

  # To refresh add :record
  load_cassette("appl-bars-aug-to-oct") do
    bars = TiingoDataDownloader.new.query("AAPL", 3.months.ago, Time.now)
  end

  data = DataHandler.new
  data.stream = bars.first(3)

  strategy = Strategy.new("buy_and_hold")
  strategy.set_algo(
    RunDailyAlgorithm.new,
    SignalAlgorithm.new(direction: :buy)
  )
  strategy.add_child Asset.new("AAPL")

  backtest = Backtest.new(initial_cash: 1000.0_f64, data: data, strategy: strategy)

  backtest.run

  backtest.statistics.print_summary
end

puts [1,2,3,4].stddev

## include AlgoBacktester::Api
## Kemal.run
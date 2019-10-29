# Simple Moving Average Crossing Strategy
# ----------------------
# This strategy buys shares of Apple every month and holds them
# until the backtest ends.

# In your code, add "algo-backtest" to your shards.yml and
# replace the following line with: require "algo-backtester"
require "../src/algo-backtester"

include AlgoBacktester

bars = [] of Bar
# To refresh add :record
load_cassette("appl-bars-aug-to-oct") do
  bars = TiingoDataDownloader.new.query("AAPL", 3.months.ago, Time.utc)
end

data = DataHandler.new
data.stream = bars

strategy = Strategy.new("moiving_average_cross")
strategy.set_algo(
  IfAlgorithm.new(
    AndAlgorithm.new(
      GreaterThanAlgorithm.new(SMAAlgorithm.new(50), SMAAlgorithm.new(200)),
      IsNotInvestedAlgorithm.new
    ),
    SignalAlgorithm.new(direction: :buy)
  ),
  IfAlgorithm.new(
    AndAlgorithm.new(
      LessThanAlgorithm.new(SMAAlgorithm.new(50), SMAAlgorithm.new(200)),
      IsInvestedAlgorithm.new
    ),
    SignalAlgorithm.new(direction: :exit)
  )
)
strategy.add_child Asset.new("AAPL")

backtest = Backtest.new(initial_cash: 1000.0_f64, data: data, strategy: strategy)

backtest.run

backtest.statistics.print_summary

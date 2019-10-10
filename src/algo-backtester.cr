# require "./data_downloader/tiingo_data_downloader.cr"
require "./**"

# TODO: Write documentation for `Algo::Backtester`
module Algo::Backtester
  VERSION = "0.1.0"
  bars = TiingoDataDownloader.new.query("AAPL", 3.months.ago, Time.now)
  data = DataHandler.new
  data.stream = bars

  symbols = ["AAPL"]

  strategy = AbstractStrategy.new("buy-and-hold")

  backtest = Backtest.new(symbols: symbols, data: data, strategy: strategy)

  backtest.run

  backtest.statistics.print_summary
end

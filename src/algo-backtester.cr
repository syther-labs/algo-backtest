require "./data_downloader/tiingo_data_downloader.cr"
# TODO: Write documentation for `Algo::Backtester`
module Algo::Backtester
  VERSION = "0.1.0"

  TiingoDataDownloader.query("AAPL", 3.months.ago, Time.now)
end

require "./data_downloader/tiingo_data_downloader.cr"
require "./*"
require "./engine/tree/node.cr"

# TODO: Write documentation for `Algo::Backtester`
module Algo::Backtester
  VERSION = "0.1.0"

  bars = TiingoDataDownloader.new.query("AAPL", 3.months.ago, Time.now)
  n = Node.new(name = "Mike")
  n.add_child Node.new(name = "Joe")
  n.set_children(Node.new("Mark"), Node.new("Tudor"), Node.new("Dalton"))
  puts n.is_root?
end

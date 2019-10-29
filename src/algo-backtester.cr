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
end

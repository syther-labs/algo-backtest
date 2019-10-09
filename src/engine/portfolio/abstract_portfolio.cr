require "../event/*"

module Algo::Backtester
  abstract class AbstractPortfolio
    abstract def on_signal(event : Event, data_handler : DataHandler)
    abstract def on_fill(event : Event, data_handler : DataHandler)
    abstract def is_invested(symbol : String) : Position
  end
end

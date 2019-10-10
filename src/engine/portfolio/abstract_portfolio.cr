module Algo::Backtester
  abstract class AbstractPortfolio
    property initial_cash : Float64
    property cash : Float64
    property value : Float64

    # As this is an abstract class, this method will
    # never be called but without it, we run into an issue
    # where the initialize does not include all instance variables
    def initialize(@initial_cash, @cash, @value)
    end

    abstract def on_signal(signal : SignalEvent, data_handler : DataHandler)
    abstract def on_fill(fill : FillEvent, data_handler : DataHandler)
    abstract def is_invested(symbol : String) : Position?
    abstract def is_long(symbol : String) : Position?
    abstract def is_short(symbol : String) : Position?
    abstract def update(bar : Bar)
    abstract def reset
    abstract def value : Float64
  end
end

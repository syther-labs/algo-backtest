require "json"

require "./abstract_event.cr"

module Algo::Backtester
  struct Bar < AbstractEvent
    getter adj_close : Float32
    getter adj_high : Float32
    getter adj_low : Float32
    getter adj_open : Float32
    getter adj_volume : Int32
    getter close : Float32
    getter div_cash : Float32
    getter high : Float32
    getter low : Float32
    getter split_factor : Float32
    getter volume : Int32

    def initialize(@symbol, @timestamp, @adj_close, @adj_high, @adj_low, @adj_open, @adj_volume, @close,
                   @div_cash, @high, @low, @split_factor, @volume)
    end

    def price
      return close
    end
  end
end

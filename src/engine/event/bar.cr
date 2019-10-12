require "json"

require "./abstract_event.cr"

module Algo::Backtester
  struct Bar < AbstractEvent
    getter adj_close : Float64
    getter adj_high : Float64
    getter adj_low : Float64
    getter adj_open : Float64
    getter adj_volume : Int64
    getter open : Float64
    getter close : Float64
    getter div_cash : Float64
    getter high : Float64
    getter low : Float64
    getter split_factor : Float64
    getter volume : Int64

    def initialize(@symbol, @timestamp, @adj_close, @adj_high, @adj_low, @adj_open, @adj_volume, @open, @close,
                   @div_cash, @high, @low, @split_factor, @volume)
    end

    def price : Float64
      return close
    end

    def to_s
      return "Bar on #{timestamp.to_s("%Y-%m-%d")} for #{symbol} (#{open}, #{high}, #{low}, #{close})"
    end
  end
end

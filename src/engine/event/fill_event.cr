require "./abstract_event.cr"
require "./direction.cr"

module Algo::Backtester
  struct FillEvent < AbstractEvent
    property direction : Direction
    property quantity : Int64
    property price : Float64
    property commission : Float64
    property exchange_fee : Float64
    # the total cost of the filled order incl commission and fees
    property cost : Float64

    def value : Float64
      return quantity * price
    end

    def net_value : Float64
      nv = value()
      nv += direction == Direction::BOT ? cost : -cost
      return nv
    end
  end
end

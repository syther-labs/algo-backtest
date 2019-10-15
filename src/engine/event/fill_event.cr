module Algo::Backtester
  struct FillEvent < AbstractEvent
    property direction : Direction
    property quantity : Int64
    property price : Float64
    property commission : Float64
    property exchange_fee : Float64
    # the total cost of the filled order incl commission and fees
    property cost : Float64

    def initialize(@timestamp, @symbol, @direction, @quantity, @price, @commission, @exchange_fee)
      @cost = @commission + @exchange_fee
    end

    def value : Float64
      return quantity * price
    end

    def net_value : Float64
      nv = value()
      nv += direction == Direction::Buy ? cost : -cost
      return nv
    end
  end
end

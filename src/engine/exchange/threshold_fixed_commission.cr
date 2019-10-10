module Algo::Backtester
  class ThresholdFixedCommission < AbstractCommission
    property commission : Float64
    property min_value : Float64

    def initialize(@commission, @min_value)
    end

    def calculate(quantity : Int64, price : Float64)
      return 0 if quantity == 0 || price == 0
      return 0 if @min_value > (quantity * price)
      return @commission
    end
  end
end

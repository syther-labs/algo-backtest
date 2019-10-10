module Algo::Backtester
  class FixedCommission < AbstractCommission
    property commission : Float64

    def initialize(@commission)
    end

    def calculate(quantity : Int64, price : Float64) : Float64
      return 0_f64 if quantity == 0 || price == 0
      return @commission
    end
  end
end

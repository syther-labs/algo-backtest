module Algo::Backtester
  class PercentageCommission < AbstractCommission
    property commission_perc : Float64

    def initialize(@commission_perc)
    end

    def calculate(quantity : Int64, price : Float64)
      return 0 if quantity == 0 || price == 0
      return quantity * price * @commission_perc
    end
  end
end

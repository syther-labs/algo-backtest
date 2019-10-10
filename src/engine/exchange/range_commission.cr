module Algo::Backtester
  class RangeCommission < AbstractCommission
    property commission_perc : Float64
    property min_commission : Float64
    property max_commission : Float64

    def initialize(@commission_perc, @min_commission, @max_commission)
    end

    def calculate(quantity : Int64, price : Float64)
      return 0 if quantity == 0 || price == 0
      raw_commission = quantity * price * @commission_perc
      return @min_commission if @min_commission > raw_commission
      return @max_commission if @max_commission < raw_commission
      return raw_commission
    end
  end
end

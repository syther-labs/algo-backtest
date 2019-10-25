module AlgoBacktester::StockExchange
  class RangeCommission < AbstractCommission
    property commission_perc : Float64
    property min_commission : Float64
    property max_commission : Float64

    def initialize(@commission_perc, @min_commission, @max_commission)
      raise InvalidParameterError.new("Commission % must be between 0 and 1") unless 0 <= @commission_perc <= 1
      raise InvalidParameterError.new("Min + max commission must be >= 0") unless @min_commission >= 0 && @max_commission >= 0
      raise InvalidParameterError.new("Max comission < min commission") unless @max_commission > @min_commission
    end

    def calculate(quantity : Int64, price : Float64) : Float64
      return 0_f64 if quantity == 0 || price == 0
      raw_commission = quantity * price * @commission_perc
      return @min_commission if @min_commission > raw_commission
      return @max_commission if @max_commission < raw_commission
      return raw_commission
    end
  end
end

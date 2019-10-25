module AlgoBacktester::StockExchange
  class PercentageCommission < AbstractCommission
    property commission_perc : Float64

    def initialize(@commission_perc)
      raise InvalidParameterError.new("Commission % must be between 0 and 1") unless 0 <= @commission_perc <= 1
    end

    def calculate(quantity : Int64, price : Float64) : Float64
      return 0_f64 if quantity == 0 || price == 0
      return quantity * price * @commission_perc
    end
  end
end

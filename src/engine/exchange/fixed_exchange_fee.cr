module AlgoBacktester::StockExchange
  class FixedExchangeFee < AbstractExchangeFee
    property exchange_fee : Float64

    def initialize(@exchange_fee)
      raise InvalidParameterError.new("Exchange fee is negative") if @exchange_fee < 0
    end

    def fee : Float64
      return @exchange_fee
    end
  end
end

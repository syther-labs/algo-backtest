module AlgoBacktester::StockExchange
  class FixedExchangeFee < AbstractExchangeFee
    property exchange_fee : Float64

    def initialize(@exchange_fee)
    end

    def fee : Float64
      return @exchange_fee
    end
  end
end

module Algo::Backtester
  class FixedExchangeFee < AbstractExchangeFee
    property exchange_fee : Float64

    def initialize(@exchange_fee)
    end

    def fee
      return @exchange_fee
    end
  end
end

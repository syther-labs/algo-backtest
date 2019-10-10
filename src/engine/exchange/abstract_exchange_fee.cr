module Algo::Backtester
  abstract class AbstractExchangeFee
    abstract def fee : Float64
  end
end

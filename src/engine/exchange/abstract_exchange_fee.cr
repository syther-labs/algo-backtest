module AlgoBacktester::StockExchange
  abstract class AbstractExchangeFee
    abstract def fee : Float64
  end
end

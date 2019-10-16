module AlgoBacktester::StockExchange
  abstract class AbstractExchange
    abstract def on_data(bar : BarEvent) : FillEvent?
    abstract def on_order(order : OrderEvent, data : DataHandler) : FillEvent
  end
end

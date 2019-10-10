module Algo::Backtester
  abstract class AbstractExchange
    abstract def on_data(bar : BarEvent) : FillEvent?
    abstract def on_order(order : OrderEvent, bar : Bar) : FillEvent
  end
end

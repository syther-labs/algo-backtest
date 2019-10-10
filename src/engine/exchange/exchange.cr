module Algo::Backtester
  class Exchange < AbstractExchange
    property symbol : String
    property commission : AbstractCommission
    property exchange_fee : AbstractExchange

    def initialize(@symbol, @commission, @exchange_fee)
    end

    # on_data executes any open order on new data
    def on_data(bar : BarEvent) : FillEvent?
    end

    def on_order(order : OrderEvent, bar : Bar) : FillEvent
      # Assumes no price slippage occurs
      latest_price = bar.latest(order.symbol)

      # Assumes all orders are filled at desired quantity and latest price
      ord_commish = @commission.calculate(order.quantity, latest_price)
      exc_fee = @exchange_fee.fee

      fill_cost = ord_commish + exc_fee

      return FillEvent.new(
        symbol: order.symbol,
        timestamp: order.timestamp,
        direction: order.direction,
        quantity: order.quantity,
        price: latest_price,
        commission_fee: ord_commish,
        exchange_fee: exc_fee,
        cost: fill_cost
      )
    end
  end
end

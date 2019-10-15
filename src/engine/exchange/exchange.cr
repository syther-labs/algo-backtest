module Algo::Backtester
  class Exchange < AbstractExchange
    property symbol : String
    property commission : AbstractCommission
    property exchange_fee : AbstractExchangeFee

    def initialize(@symbol, @commission, @exchange_fee)
    end

    # on_data executes any open order on new data
    def on_data(bar : Bar) : FillEvent?
    end

    def on_order(order : OrderEvent, data : DataHandler) : FillEvent
      # Assumes no price slippage occurs
      unless latest_price = data.latest(order.symbol)
        raise EmptyDataHandlerError.new("Trying to place order for security with no data")
      end
      # Assumes all orders are filled at desired quantity and latest price

      ord_commish = @commission.calculate(order.quantity, latest_price.price)
      exc_fee = @exchange_fee.fee

      return FillEvent.new(
        symbol: order.symbol,
        timestamp: order.timestamp,
        direction: order.direction,
        quantity: order.quantity,
        price: latest_price.price,
        commission: ord_commish,
        exchange_fee: exc_fee,
      )
    end
  end
end

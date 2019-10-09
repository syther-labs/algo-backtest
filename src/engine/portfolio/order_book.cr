require "../event/order_event.cr"

module Algo::Backtester
  class OrderBook
    # This means id's start at 0.
    @counter = -1_i64
    @orders = [] of OrderEvent
    @history = [] of OrderEvent

    def add(order : OrderEvent)
      # increment counter
      @counter += 1_i64

      # assign an id to a counter
      order.id = @counter

      @orders << order
    end

    def remove(id : Int64) : Bool
      if id < 0 && id > size
        return false
      end

      order = @orders.find { |o| o.id == id }

      if order
        @history << order
        @orders.delete(order)
        return true
      end

      return false
    end

    def size
      @orders.size
    end

    # TODO orderBy
  end
end

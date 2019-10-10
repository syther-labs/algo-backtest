module Algo::Backtester
  class SizeHandler
    @default_size : Int64
    @default_value : Float64

    def initialize(@default_size, @default_value)
    end

    def size_order(order : OrderEvent, bar : Bar, portfolio : AbstractPortfolio) : OrderEvent
      # Remember that orders are passed by value so we have to return the updated order
      if @default_size == 0 || @default_value == 0
        raise Exception.new("cannot size order - default order size and value not set")
      end

      case order.direction
      when Direction::BGHT
        order.quantity = set_default_size(bar.price)
      when Direction::SOLD
        order.quantity = set_default_size(bar.price)
      when Direction::EXIT
        unless portfolio.is_invested(order.symbol)
          raise Exception.new("no holding to exit from")
        end

        if pos = portfolio.is_long(order.symbol)
          order.quantity = pos.quantity
        elsif pos = portfolio.is_short(order.symbol)
          order.quantity = -pos.quantity
        end
      end

      return order
    end

    private def set_default_size(price : Float64) : Int64
      if @default_size * price > @default_value
        corrected_quantity = (@default_value / price).floor.to_i64
        return corrected_quantity
      end
      return @default_size
    end
  end
end

module Algo::Backtester
  class Position
    # current qty of the position, positive on BOHT position, negativ on SLD position
    getter symbol : String
    getter quantity : Int64 = 0_i64
    getter timestamp : Time
    getter quantity_bht : Int64 = 0_i64 # how many bought
    getter quantity_sld : Int64 = 0_i64 # how many sold

    getter avg_price : Float64 = 0.0_f64     # average price without cost
    getter avg_price_net : Float64 = 0.0_f64 # average price including cost
    getter avg_price_bht : Float64 = 0.0_f64 # average price BOHT, without cost
    getter avg_price_sld : Float64 = 0.0_f64 # average price SLD, without cost
    getter value : Float64 = 0.0_f64         # qty * price
    getter value_bht : Float64 = 0.0_f64     # qty BOHT * price
    getter value_sld : Float64 = 0.0_f64     # qty SLD * price
    getter net_value : Float64 = 0.0_f64     # current value - cost
    getter net_value_bht : Float64 = 0.0_f64 # current BOHT value + cost
    getter net_value_sld : Float64 = 0.0_f64 # current SLD value - cost
    getter market_price : Float64 = 0.0_f64  # last known market price
    getter market_value : Float64 = 0.0_f64  # qty * price
    getter commission : Float64 = 0.0_f64
    getter exchange_fee : Float64 = 0.0_f64
    getter cost : Float64 = 0.0_f64       # commission + fees
    getter cost_basis : Float64 = 0.0_f64 # absolute qty * avg price net

    getter real_profit_loss : Float64 = 0.0_f64
    getter unreal_profit_loss : Float64 = 0.0_f64
    getter total_profit_loss : Float64 = 0.0_f64

    def initialize(fill : FillEvent)
      @symbol = fill.symbol
      @timestamp = fill.timestamp
      update_helper!(fill)
    end

    def update!(fill : FillEvent)
      @timestamp = fill.timestamp
      update_helper!(fill)
    end

    def update_value!(bar : Bar)
      @timestamp = bar.timestamp
      latest_price = bar.price
      update_value_helper!(latest_price)
    end

    private def update_helper!(fill : FillEvent)
      case fill.direction
      when Algo::Backtester::Direction::Buy
        update_helper_bought!(fill)
      when Algo::Backtester::Direction::Sell
        update_helper_sold!(fill)
      end

      @commission += fill.commission
      @exchange_fee += fill.exchange_fee
      @cost += fill.cost
      @value = @value_sld - @value_bht
      @net_value = @value - @cost

      update_value_helper!(fill.price)
    end

    private def update_helper_bought!(fill : FillEvent)
      # if position is long
      if @quantity >= 0
        @cost_basis += fill.net_value
      else
        # position is short, closing partially out
        @cost_basis += fill.quantity.abs / @quantity * @cost_basis
        @real_profit_loss += fill.quantity * (@avg_price_net - fill.price) - fill.cost
      end

      @avg_price = ((@quantity.abs * @avg_price) + (fill.quantity * fill.price)) / (@quantity.abs + fill.quantity)
      @avg_price_net = (@quantity.abs * @avg_price_net + fill.net_value) / (@quantity.abs + fill.quantity)
      @avg_price_bht = ((@quantity_bht * @avg_price_bht) + (fill.quantity * fill.price)) / (quantity_bht + fill.quantity)

      # update position quantity
      @quantity += fill.quantity
      @quantity_bht += fill.quantity

      @value_bht = @quantity_bht * @avg_price_bht
      @net_value_bht += fill.net_value
    end

    private def update_helper_sold!(fill : FillEvent)
      # position is long, closing partially out
      if @quantity >= 0
        @cost_basis -= fill.quantity.abs / @quantity * @cost_basis
        @real_profit_loss += fill.quantity.abs * (fill.price - @avg_price_net) - fill.cost
      else # position is short, adding to position
        @cost_basis -= fill.net_value
      end

      @avg_price = ((@quantity.abs * @avg_price) + (fill.quantity * fill.price)) / (@quantity.abs + fill.quantity)
      @avg_price_net = (@quantity.abs * @avg_price_net + fill.net_value) / (@quantity.abs + fill.quantity)
      @avg_price_sld = ((@quantity_bht * @avg_price_sld) + (fill.quantity * fill.price)) / (quantity_sld + fill.quantity)

      @quantity -= fill.quantity
      @quantity_sld += fill.quantity

      @value_sld = @quantity_sld * @avg_price_sld
      @net_value_sld += fill.net_value
    end

    private def update_value_helper!(latest_price : Float64)
      @market_price = latest_price
      @market_value = @quantity.abs * latest_price
      @unreal_profit_loss = @quantity * latest_price - @cost_basis
      @total_profit_loss = @real_profit_loss + @unreal_profit_loss
    end
  end
end

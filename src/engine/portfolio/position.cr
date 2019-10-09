module Algo::Backtester
  class Position
    # current qty of the position, positive on BOT position, negativ on SLD position
    @quantity : Int64 = 0
    @quantity_bht : Int64 = 0_i64 # how many bought
    @quantity_sld : Int64 = 0_i64 # how many sold

    @avg_price : Float64 = 0.0_f64     # average price without cost
    @avg_price_net : Float64 = 0.0_f64 # average price including cost
    @avg_price_bht : Float64 = 0.0_f64 # average price BOT, without cost
    @avg_price_sld : Float64 = 0.0_f64 # average price SLD, without cost
    @value : Float64 = 0.0_f64         # qty * price
    @value_bht : Float64 = 0.0_f64     # qty BOT * price
    @value_sld : Float64 = 0.0_f64     # qty SLD * price
    @net_value : Float64 = 0.0_f64     # current value - cost
    @net_value_bht : Float64 = 0.0_f64 # current BOT value + cost
    @net_value_sld : Float64 = 0.0_f64 # current SLD value - cost
    @market_price : Float64 = 0.0_f64  # last known market price
    @market_value : Float64 = 0.0_f64  # qty * price
    @commission : Float64 = 0.0_f64
    @exchange_fee : Float64 = 0.0_f64
    @cost : Float64 = 0.0_f64       # commission + fees
    @cost_basis : Float64 = 0.0_f64 # absolute qty * avg price net

    @real_profit_loss : Float64 = 0.0_f64
    @unreal_profit_loss : Float64 = 0.0_f64
    @total_profit_loss : Float64 = 0.0_f64

    def initialize(fill : FillEvent)
      @symbol = fill.symbol
      @timestamp = fill.timestamp
    end

    def update!(fill : FillEvent)
      @timestamp = fill.timestamp
      update_helper!(fill)
    end

    def update_value!(fill : FillEvent)
      @timestamp = fill.timestamp
      latest_price = fill.price
      update_value_helper!(latest_price)
    end

    private def update_helper!(fill : FillEvent)
      case fill.direction
      when Algo::Backtester::Direction::BOT
        # if position is long
        if @quantity >= 0
          @cost_basis += fill.net_value
        else
          # position is short, closing partially out
          @cost_basis += abs(fill.quantity) / @quantity * @cost_basis
          @real_profit_loss += fill.quantity * (@avg_price_net - fill.price) - fill.cost
        end

        @avg_price = ((abs(@quantity) * @avg_price) + (fill.quantity * fill.price)) / (abs(@quantity) + fill.quantity)
        @avg_price_net = (abs(@quantity) * @avg_price_net + fill.net_value) / (abs(@quantity) + fill.quantity)
        @avg_price_bht = ((@quantity_bht * @avg_price_bht) + (fill.quantity * fill.price)) / (quantity_bht + fill.quantity)

        # update position quantity
        @quantity += fill.quantity
        @quantity_bht += fill.quantity

        @value_bht = @quantity_bht * @avg_price_bht
        @net_value_bht += fill.net_value
      when Algo::Backtester::Direction::SLD
        # position is long, closing partially out
        if @quantity >= 0
          @cost_basis -= abs(fill.quantity) / @quantity * @cost_basis
          @real_profit_loss += abs(fill.quantity) * (@fill_price - @avg_price_net) - fill.cost
        else # position is short, adding to position
          @cost_basis -= fill.net_value
        end

        @avg_price = ((abs(@quantity) * @avg_price) + (fill.quantity * fill.price)) / (abs(@quantity) + fill.quantity)
        @avg_price_net = (abs(@quantity) * @avg_price_net + fill.net_value) / (abs(@quantity) + fill.quantity)
        @avg_price_sld = ((@quantity_bht * @avg_price_sld) + (fill.quantity * fill.price)) / (quantity_sld + fill.quantity)

        @quantity -= fill.quantity
        @quantity_sld += fill.quantity

        @value_sld = @quantity_sld * @avg_price_sld
        @net_value_sld += fill.net_value
      end

      @commission += fill.commission
      @exchange_fee += fill.exchange_fee
      @cost += fill.cost
      @value = @value_sld - @value_bht
      @net_value = @value - @cost

      update_value(fill.price)
    end

    private def update_value_helper!(latest_price : Float64)
      @market_price = latest_price
      @market_value = abs(@quantity) * latest_price
      @unreal_profit_loss = @quantity * latest_price - cost_basis
      @total_profit_loss = @real_profit_loss + @unreal_profit_loss
    end
  end
end

module Algo::Backtester
  class Portfolio < AbstractPortfolio
    @initial_cash : Float64
    @cash : Float64
    getter holdings : Hash(String, Position)
    getter size_handler : SizeHandler
    @transactions : Array(FillEvent)
    @next_order_id : Int64

    def initialize(@initial_cash : Float64)
      @cash = @initial_cash
      @holdings = Hash(String, Position).new
      @size_handler = SizeHandler.new(default_size: 10_i64, default_value: 1000_f64)
      @transactions = [] of FillEvent
      @next_order_id = 1_i64
    end

    def on_signal(signal : SignalEvent, data_handler : DataHandler)
      # TODO: Add limit orders!
      initial_order = OrderEvent.new(
        id: @next_order_id,
        timestamp: signal.timestamp,
        symbol: signal.symbol,
        direction: signal.direction,
        type: OrderType::Market,
        status: OrderStatus::Open,
        quantity: 1_i64,       # to be overwritten by sizer.
        asset_type: "SECURITY" # is this a parameter?
      )
      @next_order_id += 1
      unless latest_price = data_handler.latest(signal.symbol)
        raise EmptyDataHandlerError.new("trying to add signal for symbol with no data")
      end

      sized_order = @size_handler.size_order(initial_order, latest_price, self)

      return sized_order
    end

    def on_fill(fill : FillEvent, data_handler : DataHandler)
      if @holdings.has_key?(fill.symbol)
        pos = @holdings[fill.symbol]
        pos.update!(fill)
        @holdings[fill.symbol] = pos
      else
        pos = Position.new(fill)
        @holdings[fill.symbol] = pos
      end

      # Update cash
      case fill.direction
      when Direction::Buy  then @cash -= fill.net_value
      when Direction::Sell then @cash += fill.net_value
      else
        raise InvalidParameterError.new("Shouldn't have hold or exit fills")
      end

      @transactions << fill

      return fill
    end

    def is_invested(symbol : String) : Position?
      if @holdings.has_key?(symbol)
        pos = @holdings[symbol]
        return pos if pos.quantity != 0
      end
      return nil
    end

    def is_long(symbol : String) : Position?
      if @holdings.has_key?(symbol)
        pos = @holdings[symbol]
        return pos if pos.quantity > 0
      end
      return nil
    end

    def is_short(symbol : String) : Position?
      if @holdings.has_key?(symbol)
        pos = @holdings[symbol]
        return pos if pos.quantity < 0
      end
      return nil
    end

    def update!(bar : Bar)
      if pos = is_invested(bar.symbol)
        pos.update_value!(bar)
        @holdings[bar.symbol] = pos
      end
    end

    def reset!
      @cash = @initial_cash
      @holdings = Hash(String, Position).new
      @transactions = [] of FillEvent
    end

    def value : Float64
      holding_value = @holdings.values.map(&.market_value).sum
      return @cash + holding_value
    end
  end
end

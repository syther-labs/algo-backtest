module Algo::Backtester
  class Portfolio < AbstractPortfolio
    DEFAULT_INITIAL_CASH = 100_000_f64

    getter holdings : Hash(String, Position)
    getter size_handler : SizeHandler
    @transactions : Array(FillEvent)

    def initialize(@initial_cash = DEFAULT_INITIAL_CASH)
      @cash = @initial_cash
      @value = @initial_cash
      @holdings = Hash(String, Position).new
      @size_handler = SizeHandler.new(default_size: 10_i64, default_value: 1000_f64)
      @transactions = [] of FillEvent
    end

    def on_signal(signal : SignalEvent, data_handler : DataHandler)
      # Todo figure out how to set this dynamically
      initial_order = OrderEvent.new(
        id: -1_i64,
        timestamp: signal.timestamp,
        symbol: signal.symbol,
        direction: signal.direction,
        type: OrderType::Market,
        status: OrderStatus::Submitted,
        quantity: 1_i64, # to be overwritten by sizer.
        asset_type: "SECURITY" # is this a parameter?
      )
      unless latest_price = data_handler.latest(signal.symbol)
        raise Exception.new("trying to add signal for symbol with no data")
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
      when Direction::BGHT
        @cash -= fill.net_value
      when Direction::SOLD
        @cash += fill.net_value
      else
        raise Exception.new("Shouldn't have hold or exit fills")
      end

      @transactions << fill
    end

    def is_invested(symbol : String) : Position?
      if pos = @holdings[symbol]
        return pos if pos.quantity != 0
      end
      return nil
    end

    def is_long(symbol : String) : Position?
      if pos = @holdings[symbol]
        return pos if pos.quantity > 0
      end
      return nil
    end

    def is_short(symbol : String) : Position?
      if pos = @holdings[symbol]
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
      @initial_cash = DEFAULT_INITIAL_CASH
      @cash = @initial_cash
      @value = @initial_cash
    end

    def value : Float64
      holding_value : Float64 = 0
      @holdings.values.each do |pos|
        holding_value += pos.market_value
      end

      return @cash + holding_value
    end
  end
end

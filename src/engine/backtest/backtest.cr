module Algo::Backtester
  class Backtest
    property symbols : Array(String)
    property data : DataHandler
    property strategy : AbstractStrategy
    property portfolio : AbstractPortfolio
    property exchange : AbstractExchange
    property statistics : StatisticHandler
    property event_queue : Array(AbstractEvent)

    def initialize(
      @symbols,
      @data,
      @strategy,
      @portfolio = Portfolio.new,
      @exchange = Exchange.new(
        symbol: "MIKE",
        commission: FixedCommission.new(0_f64),
        exchange_fee: FixedExchangeFee.new(0_f64)
      ),
      @event_queue = [] of AbstractEvent,
      @statistics = StatisticHandler.new
    )
    end

    def setup
      @strategy.data = @data
      @strategy.portfolio = @portfolio
    end

    def teardown
      # TBD if necessary
    end

    def reset!
      @event_queue = [] of AbstractEvent
      @data.reset!
      @portfolio.reset!
      @statistics.reset!
    end

    def run
      setup

      while true
        puts "Remaining.....#{@event_queue.size}"
        # STOPPING CONDITION: If we are out of events and data then we stop
        if @event_queue.empty?
          break if @data.empty?

          @event_queue << @data.next!
        end

        event = @event_queue.shift
        process_event(event)

        @statistics.track_event(event)
      end

      teardown
    end

    private def process_event(event : AbstractEvent)
      case event
      when Bar
        @portfolio.update!(event)
        @statistics.update!(event, @portfolio)
        
        @exchange.on_data(event)
        
        signals = strategy.on_data(event)
        @event_queue.concat(signals)

      when SignalEvent
        order = @portfolio.on_signal(event, @data)
        @event_queue << order
      when OrderEvent
        order = @exchange.on_order(event, @data)
        @event_queue << order
      when FillEvent
        transaction = @portfolio.on_fill(event, @data)
        # track transaction
      end
    end
  end
end

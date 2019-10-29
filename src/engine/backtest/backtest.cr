require "colorize"

module AlgoBacktester
  class Backtest
    property data : DataHandler
    property strategy : AbstractStrategy
    property portfolio : AbstractPortfolio
    property exchange : AbstractExchange
    property statistics : StatisticHandler
    property event_queue : Array(AbstractEvent)

    PRINT_TITLE_BORDER_WIDTH = 25 # chars

    def initialize(
      @data,
      @strategy,
      initial_cash : Float64,
      @exchange = Exchange.new(
        symbol: "MIKE",
        commission: PercentageCommission.new(0.01_f64),
        exchange_fee: FixedExchangeFee.new(0_f64)
      )
    )
      @portfolio = Portfolio.new(initial_cash)
      @statistics = StatisticHandler.new
      @event_queue = [] of AbstractEvent
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

      print_title "Starting backtest...."

      while true
        # STOPPING CONDITION: If we are out of events and data then we stop
        if @event_queue.empty?
          break if @data.empty?

          @event_queue << @data.next!
        end

        event = @event_queue.shift

        print_colorized_event(event)

        process_event(event)

        @statistics.track_event(event)
      end

      teardown

      print_title "Ending backtest...."
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
        @portfolio.on_fill(event, @data)
        @statistics.track_transaction(event)
      end
    end

    private def print_colorized_event(event : AbstractEvent)
      kPrefix = "Processing: "
      case event
      when Bar
        puts "#{kPrefix}#{event.to_s}".colorize(:default)
      when SignalEvent
        puts "#{kPrefix}#{event.to_s}".colorize(:blue)
      when OrderEvent
        puts "#{kPrefix}#{event.to_s}".colorize(:magenta)
      when FillEvent
        puts "#{kPrefix}#{event.to_s}".colorize(:yellow)
      end
    end

    private def print_title(msg : String)
      border = "-" * PRINT_TITLE_BORDER_WIDTH
      puts "#{border}\n- #{msg}\n#{border}"
    end
  end
end

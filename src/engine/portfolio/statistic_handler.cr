module AlgoBacktester
  class StatisticHandler
    struct EquityPoint
      property timestamp : Time
      property equity : Float64
      property equity_return : Float64
      property drawdown : Float64

      def initialize(@timestamp, @equity, @equity_return, @drawdown)
      end
    end

    @event_history : Array(AbstractEvent)
    @transaction_history : Array(FillEvent)
    @equity_history : Array(EquityPoint)
    @low : EquityPoint
    @high : EquityPoint

    def initialize
      @event_history = [] of AbstractEvent
      @transaction_history = [] of FillEvent
      @equity_history = [] of EquityPoint
      @high = EquityPoint.new(timestamp: Time.utc, equity: 0_f64, equity_return: 0_f64, drawdown: 0_f64)
      @low = EquityPoint.new(timestamp: Time.utc, equity: 0_f64, equity_return: 0_f64, drawdown: 0_f64)
    end

    def track_event(event : AbstractEvent)
      @event_history << event
    end

    def events
      @event_history
    end

    def track_transaction(fill : FillEvent)
      @transaction_history << fill
    end

    def transactions
      @transaction_history
    end

    def update!(bar : Bar, portfolio : AbstractPortfolio)
      equity = portfolio.value
      equity_return = calc_equity_return(equity)
      drawdown = calc_drawdown(equity)
      ep = EquityPoint.new(
        timestamp: bar.timestamp,
        equity: equity,
        equity_return: equity_return,
        drawdown: drawdown
      )

      if equity >= @high.equity
        @high.equity = equity
      end

      if equity <= @low.equity
        @low.equity = equity
      end

      @equity_history << ep
    end

    def reset!
      # Duplicate of intializer. Not DRY but indirect initialization is not support, so we move on.
      @event_history = [] of AbstractEvent
      @transaction_history = [] of FillEvent
      @equity_history = [] of EquityPoint
      @high = EquityPoint.new(timestamp: Time.now, equity: 0_f64, equity_return: 0_f64, drawdown: 0_f64)
      @low = EquityPoint.new(timestamp: Time.now, equity: 0_f64, equity_return: 0_f64, drawdown: 0_f64)
    end

    def print_summary
      bar_events = @event_history.select { |e| e.is_a?(Bar) }
      kSummaryStrTemplate = "%-30s%5s\n"
      kSummaryFltTemplate = "%-30s%5.2f\n"
      start_date, end_date = bar_events.first.timestamp, bar_events.last.timestamp

      summary = String.build do |str|
        str << "BACKTEST SUMMARY\n#{"-" * 50}\n\n"
        str << sprintf(kSummaryStrTemplate, "Start Date", start_date.to_s("%Y-%m-%d"))
        str << sprintf(kSummaryStrTemplate, "End Date", end_date.to_s("%Y-%m-%d"))
        str << sprintf(kSummaryStrTemplate, "# of events", "#{@event_history.size} events")
        str << sprintf(kSummaryStrTemplate, "# of transactions", "#{@transaction_history.size} events")
        puts # -linebreak

        str << sprintf(kSummaryFltTemplate, "Total equity return", total_equity_return())
        str << sprintf(kSummaryFltTemplate, "Sharpe ratio", sharpe_ratio(0.0))
        str << sprintf(kSummaryFltTemplate, "Sortino ratio", sortino_ratio(0.0))

        # @transaction_history.each_with_index do |trans, i|
        #   str << "\t#{i + 1}. "
        #   str << "Transaction: #{trans.timestamp.to_s("%Y-%m-%d")}, "
        #   str << "Action: #{trans.direction}, "
        #   str << "Price: #{trans.price}, "
        #   str << "Qty: #{trans.quantity}\n"
        # end
      end

      puts summary
    end

    def total_equity_return : Float64
      return 0.0_f64 if @equity_history.empty?
      first_eq_pt = @equity_history.first.equity
      last_eq_pt = @equity_history.last.equity

      return (last_eq_pt - first_eq_pt) / first_eq_pt
    end

    def sharpe_ratio(risk_free : Float64)
      equity_returns = @equity_history.map(&.equity_return)
      mean = equity_returns.mean
      stddev = equity_returns.stddev

      return (mean - risk_free) / stddev
    end

    def sortino_ratio(risk_free : Float64)
      equity_returns = @equity_history.map(&.equity_return)
      mean = equity_returns.mean

      # Sortino uses the std of only the negative returns
      neg_returns = equity_returns.reject { |r| r > 0 }
      neg_stddev = neg_returns.stddev

      return (mean - risk_free) / neg_stddev
    end

    def max_drawdown : Float64
      _, max_dd_equity_point = calc_max_drawdown_point()
      return max_dd_equity_point.drawdown
    end

    def max_drawdown_timestamp : Float64
      _, max_dd_equity_point = calc_max_drawdown_point()
      return max_dd_equity_point.timestamp
    end

    def max_drawdown_duration : Time
      return 0 if @equity_history.empty?

      max__dd_idx, max_eq_point = calc_max_drawdown_point()

      # Initial value to avoid nil.
      prev_max_eq_pt = @equity_history[0]

      # Find a prevoiusly higher point
      max__dd_idx.downto(0).each do |idx|
        if prev_max_eq_pt.nil? || @equity_history[idx].equity > prev_max_eq_pt.equity
          prev_max_eq_pt = @equity_history[idx]
        end
      end

      return max_eq_point.timestamp - prev_max_eq_pt.timestamp
    end

    private def calc_drawdown(equity : Float64) : Float64
      return 0_f64 if @high.equity == 0
      return 0_f64 if equity >= @high.equity

      return (equity - @high.equity) / @high.equity
    end

    private def calc_equity_return(equity : Float64) : Float64
      return 0_f64 if @equity_history.empty?
      last_equity_pt = @equity_history.last.equity

      return 1_f64 if last_equity_pt == 0 # if last equity point has 0 equity

      return (equity - last_equity_pt) / last_equity_pt
    end

    private def calc_max_drawdown_point : {Int64, EquityPoint?}
      return {-1, nil} if @equity_history.empty?

      max_drawdown : Float64 = 0.0_f64
      max_drawdown_idx = 0

      @equity_history.each_with_index do |eq, i|
        if eq.drawdown < max_drawdown
          max_drawdown = eq.drawdown
          max_drawdown_idx = i
        end
      end

      return {max_drawdown_idx, @equity_history[max_drawdown_idx]}
    end
  end
end

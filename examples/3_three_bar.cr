# Three-Bar Strategy
# -------------------
# A simple trading strategy based on the assumption that after three
# consecutive bullish bars (bar closing occurred higher than its opening)
# bulls predominate in the market and therefore the price will continue to grow;
# after 3 consecutive bearish bars (the bar closes lower than its opening), the
# price will continue to down, since bears predominate in the market.
# Algorithm Source: https://github.com/constverum/Quantdom

# In your code, add "algo-backtest" to your shards.yml and
# replace the following line with: require "algo-backtester"
require "../src/algo-backtester"

include AlgoBacktester

#############################################################
# In this example, we show how to create a custom algorithm.
# We need to inherit from Abstract algorithm and implement the
# `run` method. Since the backtester is tree-based, we need
# to implement these algorithms in blocks. So, we split up
# the three-bar strategy into two blocks: when the upper
# bar is met and when the lower bar is met. We use inheritance
# to keep everything DRY. And then, we plug this custom algorithm
# into the `set_algos` method of the strategy.
############################################################

abstract class AbstractThreeBar < AbstractAlgorithm
  MAX_UPPER_BAR = 3
  MAX_LOWER_BAR = 3
  @seq_upper_bar = 0
  @seq_lower_bar = 0

  def run(strategy) : {Bool, AlgorithmError?}
    return {false, AlgorithmError.new("Indicator failed because event was nil")} if (event = strategy.event).nil?
    return {false, AlgorithmError.new("Only runs on bar events")} unless event.is_a? Bar

    if event.close > event.open
      @seq_lower_bar = 0
      @seq_upper_bar += 1
    else
      @seq_lower_bar += 1
      @seq_upper_bar = 0
    end

    return threebar_logic(@seq_lower_bar == MAX_LOWER_BAR, @seq_upper_bar == MAX_UPPER_BAR)
  end

  abstract def threebar_logic(lower_bar_at_bound : Bool, upper_bar_at_bound : Bool)
end

class UpperThreeBar < AbstractThreeBar
  def threebar_logic(lower_bar_at_bound : Bool, upper_bar_at_bound : Bool)
    return {true, nil} if upper_bar_at_bound
    return {false, AlgorithmError.new("upper bar not met")}
  end
end

class LowerThreeBar < AbstractThreeBar
  def threebar_logic(lower_bar_at_bound : Bool, upper_bar_at_bound : Bool)
    return {true, nil} if lower_bar_at_bound
    return {false, AlgorithmError.new("lower bar not met")}
  end
end

#############################################################

bars = [] of Bar
# To refresh add :record
load_cassette("appl-bars-aug-to-oct") do
  bars = TiingoDataDownloader.new.query("AAPL", 3.months.ago, Time.utc)
end

data = DataHandler.new
data.stream = bars

strategy = Strategy.new("three_bars")
strategy.set_algo(
  RunDailyAlgorithm.new,
  IfAlgorithm.new(LowerThreeBar.new, SignalAlgorithm.new(direction: :sell)),
  IfAlgorithm.new(UpperThreeBar.new, SignalAlgorithm.new(direction: :buy))
)

strategy.add_child Asset.new("AAPL")

backtest = Backtest.new(initial_cash: 1000.0_f64, data: data, strategy: strategy)

backtest.run

backtest.statistics.print_summary

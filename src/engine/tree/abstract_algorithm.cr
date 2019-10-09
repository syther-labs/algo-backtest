module Algo::Backtester
  abstract class AbstractAlgorithm
    # determines if the strategy should always run, regardless of failure
    property run_always : Bool
    getter value : Int64

    abstract def run(strategy : AbstractStrategy) : Bool
  end
end

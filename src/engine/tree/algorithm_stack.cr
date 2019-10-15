module Algo::Backtester
  class AlgorithmStack < AbstractAlgorithm
    property stack : Array(AbstractAlgorithm)

    def initialize(
      @run_always = false,
      @value = 0_i64,
      @stack = [] of AbstractAlgorithm
    )
    end

    def run(strategy : AbstractStrategy) : Bool
      @stack.each do |algo|
        return false unless algo.run(strategy)
      end
      return true
    end
  end
end

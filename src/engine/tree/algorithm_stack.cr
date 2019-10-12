module Algo::Backtester
  class AlgorithmStack < AbstractAlgorithm
    property stack : Array(AbstractAlgorithm)

    def initialize(
      @run_always = false,
      @value = 0_i64,
      @stack = [] of AbstractAlgorithm
    )
    end

    def run(strategy : AbstractStrategy)
      @stack.each do |algo|
        return false if !algo.run(strategy)
      end
      return true
    end
  end
end

module AlgoBacktester::Tree
  class AlgorithmStack < AbstractAlgorithm
    property stack : Array(AbstractAlgorithm)

    def initialize(
      @run_always = false,
      @value = 0_f64,
      @stack = [] of AbstractAlgorithm
    )
    end

    def run(strategy : AbstractStrategy) : {Bool, AlgorithmError?}
      @stack.each do |algo|
        algo_was_successful, error = algo.run(strategy)
        puts [algo_was_successful, error]
        return {false, error} unless algo_was_successful
      end
      return {true, nil}
    end
  end
end

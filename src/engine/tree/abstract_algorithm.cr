module AlgoBacktester::Tree
  abstract class AbstractAlgorithm
    # determines if the strategy should always run, regardless of failure
    property run_always : Bool
    getter value : Float64

    def initialize(@run_always = false, @value = 0_f64)
    end

    abstract def run(strategy : AbstractStrategy) : {Bool, AlgorithmError?}
  end
end

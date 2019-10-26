module AlgoBacktester::Tree
  class BoolAlgorithm < AbstractAlgorithm
    @boolean : Bool

    # Returns a simple true/false algo
    def initialize(@boolean, @run_always = false, @value = 0_f64)
      super(@run_always, @value)
    end

    # Runs the algorithm, returning the bool value of the algorithm
    def run(strategy : AbstractStrategy) : {Bool, AlgorithmError?}
      return {true, nil} if @boolean
      return {false, AlgorithmError.new("Boolean parameter to BoolAlgo was false")}
    end
  end
end

module Algo::Backtester
  class BoolAlgorithm < AbstractAlgorithm
    @boolean : Bool

    # Returns a simple true/false algo
    def initialize(@boolean, @run_always = false, @value = 0_i64)
      super(@run_always, @value)
    end

    # Runs the algorithm, returning the bool value of the algorithm
    def run(strategy : AbstractStrategy) : Bool
      return @boolean
    end
  end
end

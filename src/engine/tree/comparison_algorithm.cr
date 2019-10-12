module Algo::Backtester
  class BiggerThanAlgorithm < AbstractAlgorithm
    @first : AbstractAlgorithm
    @second : AbstractAlgorithm

    # Returns a simple true/false algo
    def initialize(@first, @second, @run_always = false, @value = 0_i64)
      super(@run_always, @value)
    end

    # Runs the algorithm, returning the bool value of the algorithm
    def run(strategy : AbstractStrategy) : Bool
      result_first = @first.run(strategy)
      result_second = @second.run(strategy)
      if !result_first || !result_second
        return false
      end

      return @first.value > @second.value
    end
  end

  class LessThanAlgorithm < AbstractAlgorithm
    @first : AbstractAlgorithm
    @second : AbstractAlgorithm

    # Returns a simple true/false algo
    def initialize(@first, @second, @run_always = false, @value = 0_i64)
      super(@run_always, @value)
    end

    # Runs the algorithm, returning the bool value of the algorithm
    def run(strategy : AbstractStrategy) : Bool
      result_first = @first.run(strategy)
      result_second = @second.run(strategy)
      if !result_first || !result_second
        return false
      end

      return @first.value < @second.value
    end
  end

  class EqualToAlgorithm < AbstractAlgorithm
    @first : AbstractAlgorithm
    @second : AbstractAlgorithm

    # Returns a simple true/false algo
    def initialize(@first, @second, @run_always = false, @value = 0_i64)
      super(@run_always, @value)
    end

    # Runs the algorithm, returning the bool value of the algorithm
    def run(strategy : AbstractStrategy) : Bool
      result_first = @first.run(strategy)
      result_second = @second.run(strategy)
      if !result_first || !result_second
        return false
      end

      return @first.value == @second.value
    end
  end
end

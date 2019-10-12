module Algo::Backtester
  class IfAlgorithm < AbstractAlgorithm
    @condition : AbstractAlgorithm
    @action : AbstractAlgorithm

    # Returns a simple true/false algo
    def initialize(@condition, @action, @run_always = false, @value = 0_i64)
      super(@run_always, @value)
    end

    # Runs the algorithm, returning the bool value of the algorithm
    def run(strategy : AbstractStrategy) : Bool
      result_condition = @condition.run(strategy)
      if result_condition
        result_action = @action.run(strategy)
      end
      return true
    end
  end

  class AndAlgorithm < AbstractAlgorithm
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

      return true
    end
  end

  class OrAlgorithm < AbstractAlgorithm
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
      if !result_first && !result_second
        return false
      end

      return true
    end
  end

  class XorAlgorithm < AbstractAlgorithm
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
      if (!result_first && !result_second) || (result_first && result_second)
        return false
      end

      return true
    end
  end
end

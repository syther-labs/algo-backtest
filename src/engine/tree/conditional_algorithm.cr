module AlgoBacktester::Tree
  class IfAlgorithm < AbstractAlgorithm
    @condition : AbstractAlgorithm
    @action : AbstractAlgorithm

    # Returns a simple true/false algo
    def initialize(@condition, @action, @run_always = false, @value = 0_f64)
      super(@run_always, @value)
    end

    # Runs the algorithm, returning the bool value of the algorithm
    def run(strategy : AbstractStrategy) : {Bool, AlgorithmError?}
      result_condition, err = @condition.run(strategy)
      if result_condition
        result_action, err = @action.run(strategy)
        return {true, nil} if result_action
        return {false, AlgorithmError.new(("if condition met but result was false"))}
      end
      return {true, nil} # If condition was not met
    end
  end

  class AndAlgorithm < AbstractAlgorithm
    @first : AbstractAlgorithm
    @second : AbstractAlgorithm

    # Returns a simple true/false algo
    def initialize(@first, @second, @run_always = false, @value = 0_f64)
      super(@run_always, @value)
    end

    # Runs the algorithm, returning the bool value of the algorithm
    def run(strategy : AbstractStrategy) : {Bool, AlgorithmError?}
      result_first, err_first = @first.run(strategy)
      result_second, err_second = @second.run(strategy)
      is_and = result_first && result_second
      return {true, nil} if is_and
      return {false, AlgorithmError.new(("AND condition not held"))}
    end
  end

  class OrAlgorithm < AbstractAlgorithm
    @first : AbstractAlgorithm
    @second : AbstractAlgorithm

    # Returns a simple true/false algo
    def initialize(@first, @second, @run_always = false, @value = 0_f64)
      super(@run_always, @value)
    end

    # Runs the algorithm, returning the bool value of the algorithm
    def run(strategy : AbstractStrategy) : {Bool, AlgorithmError?}
      result_first, err_first = @first.run(strategy)
      result_second, err_second = @second.run(strategy)

      is_or = result_first || result_second
      return {true, nil} if is_or
      return {false, AlgorithmError.new(("OR condition not held"))}
    end
  end

  class XorAlgorithm < AbstractAlgorithm
    @first : AbstractAlgorithm
    @second : AbstractAlgorithm

    # Returns a simple true/false algo
    def initialize(@first, @second, @run_always = false, @value = 0_f64)
      super(@run_always, @value)
    end

    # Runs the algorithm, returning the bool value of the algorithm
    def run(strategy : AbstractStrategy) : {Bool, AlgorithmError?}
      result_first, err_first = @first.run(strategy)
      result_second, err_second = @second.run(strategy)
      is_xor = (result_first && !result_second) || (!result_first && result_second)
      return {true, nil} if is_xor
      return {false, AlgorithmError.new(("XOR condition not held"))}
    end
  end
end

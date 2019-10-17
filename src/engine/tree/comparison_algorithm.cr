module AlgoBacktester::Tree
  class BiggerThanAlgorithm < AbstractAlgorithm
    @first : AbstractAlgorithm
    @second : AbstractAlgorithm

    # Returns a simple true/false algo
    def initialize(@first, @second, @run_always = false, @value = 0_f64)
      super(@run_always, @value)
    end

    # Runs the algorithm, returning the bool value of the algorithm
    def run(strategy : AbstractStrategy) : {Bool, AlgorithmError?}
      result_first = @first.run(strategy)
      result_second = @second.run(strategy)

      return {false, AlgorithmError.new("Algos passed in to > had non-true values")} unless result_first && result_second

      is_bigger = @first.value > @second.value
      return {true, nil} if is_bigger
      return {false, AlgorithmError.new("#{result_first} was not > than #{result_second}")}
    end
  end

  class LessThanAlgorithm < AbstractAlgorithm
    @first : AbstractAlgorithm
    @second : AbstractAlgorithm

    # Returns a simple true/false algo
    def initialize(@first, @second, @run_always = false, @value = 0_f64)
      super(@run_always, @value)
    end

    # Runs the algorithm, returning the bool value of the algorithm
    def run(strategy : AbstractStrategy) : {Bool, AlgorithmError?}
      result_first = @first.run(strategy)
      result_second = @second.run(strategy)

      return {false, AlgorithmError.new("Algos passed in to < had non-true values")} unless result_first && result_second

      is_smaller = @first.value < @second.value
      return {true, nil} if is_smaller

      return {false, AlgorithmError.new("#{result_first} was not < than #{result_second}")}
    end
  end

  class EqualToAlgorithm < AbstractAlgorithm
    @first : AbstractAlgorithm
    @second : AbstractAlgorithm

    # Returns a simple true/false algo
    def initialize(@first, @second, @run_always = false, @value = 0_f64)
      super(@run_always, @value)
    end

    # Runs the algorithm, returning the bool value of the algorithm
    def run(strategy : AbstractStrategy) : {Bool, AlgorithmError?}
      result_first = @first.run(strategy)
      result_second = @second.run(strategy)

      return {false, AlgorithmError.new("Algos passed in to == had non-true values")} unless result_first && result_second

      is_equal = @first.value == @second.value
      return {true, nil} if is_equal
      return {false, AlgorithmError.new("#{result_first} was not == #{result_second}")}
    end
  end
end

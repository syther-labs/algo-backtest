module AlgoBacktester::Tree
  private abstract class AbstractPortfolioAlgorithm < AbstractAlgorithm
    @symbols : Array(String)

    # Returns a simple true/false algo
    def initialize(@symbols = Array(String), @run_always = false, @value = 0_f64)
      super(@run_always, @value)
    end

    # Terrible name but this determines what direction we are checking for.
    # If we're checking for when we're invested, we return true and nil when is_inv == T
    # If we're checking for when we're NOT invested, we return false and error_msg when is_inv == T
    abstract def investment_logic(is_inv : Bool, error_msg_if_not : String) : {Bool, AlgorithmError?}

    # Runs the algorithm, returning the bool value of the algorithm
    def run(strategy : AbstractStrategy) : {Bool, AlgorithmError?}
      return {false, AlgorithmError.new("Period Algo failed because portfolio was nil")} if (portfolio = strategy.portfolio).nil?
      return {false, AlgorithmError.new("Period Algo failed because event was nil")} if (event = strategy.event).nil?

      # If symbol array is empty, use symbol of current event
      if @symbols.empty?
        symbol = event.symbol
        return investment_logic(symbol.nil?, "Failed because not invested in #{symbol}")
      end

      is_invested = @symbols.all? { |sym| portfolio.is_invested(sym) != nil }
      return investment_logic(is_invested, "Failed because not invested in all #{@symbols}")
    end
  end

  class IsInvestedAlgorithm < AbstractPortfolioAlgorithm
    def investment_logic(is_inv : Bool, error_msg_if_not : String) : {Bool, AlgorithmError?}
      return {true, nil} if is_inv
      return {false, AlgorithmError.new(error_msg_if_not)}
    end
  end

  class IsNotInvestedAlgorithm < AbstractPortfolioAlgorithm
    def investment_logic(is_inv : Bool, error_msg_if_not : String) : {Bool, AlgorithmError?}
      return {false, AlgorithmError.new(error_msg_if_not)} if is_inv
      return {true, nil}
    end
  end
end

module AlgoBacktester::Tree
  class SignalAlgorithm < AbstractAlgorithm
    @direction : Direction

    def initialize(direction : Symbol | Direction, @run_always = false, @value = 0_f64)
      super(@run_always, @value)
      case direction
      when Symbol
        @direction = map_direction_string_to_enum(direction)
      when Direction
        @direction = direction
      else
        raise UnsupportedDirectionError.new
      end
    end

    # Runs the algorithm, returning the bool value of the algorithm
    def run(strategy : AbstractStrategy) : {Bool, AlgorithmError?}
      event = strategy.event

      return {false, AlgorithmError.new("Event for signal is nil")} if event.nil?

      strategy.add_signal(SignalEvent.new(
        timestamp: event.timestamp,
        symbol: event.symbol,
        direction: @direction
      ))
      return {true, nil}
    end

    private def map_direction_string_to_enum(direction : Symbol) : Direction
      return case direction
      when :long, :buy
        return Direction::Buy
      when :hold
        return Direction::Hold
      when :exit
        return Direction::Exit
      when :short, :sell
        return Direction::Sell
      else
        raise UnsupportedDirectionError.new("Invalid direction provided")
      end
    end
  end
end

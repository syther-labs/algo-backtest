module Algo::Backtester
  class SignalAlgorithm < AbstractAlgorithm
    @direction : Direction

    def initialize(direction : Symbol | Direction, @run_always = false, @value = 0_i64)
      super(@run_always, @value)
      case direction
      when Symbol
        @direction = map_direction_string_to_enum(direction)
      when Direction
        @direction = direction
      else
        raise Exception.new("This should never occur.")
      end
    end

    # Runs the algorithm, returning the bool value of the algorithm
    def run(strategy : AbstractStrategy) : Bool
      event = strategy.event

      return false if event.nil?

      strategy.add_signal(SignalEvent.new(
        timestamp: event.timestamp,
        symbol: event.symbol,
        direction: @direction
      ))
      return true
    end

    private def map_direction_string_to_enum(direction : Symbol) : Direction
      return case direction
      when :long, :buy
        return Direction::BGHT
      when :hold
        return Direction::HOLD
      when :exit
        return Direction::EXIT
      when :short, :sell
        return Direction::SOLD
      else
        raise Exception.new("Invalid direction provided")
      end
    end
  end
end

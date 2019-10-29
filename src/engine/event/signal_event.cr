module AlgoBacktester::Event
  struct SignalEvent < AbstractEvent
    property direction : Direction

    def initialize(@timestamp, @symbol, @direction)
    end

    def to_s : String
      return "Signal(ts: #{@timestamp.to_s("%Y-%m-%d")}, sym: #{@symbol}, \
      dir: #{@direction})"
    end
  end
end

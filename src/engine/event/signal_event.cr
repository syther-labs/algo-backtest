module AlgoBacktester::Event
  struct SignalEvent < AbstractEvent
    property direction : Direction

    def initialize(@timestamp, @symbol, @direction)
    end
  end
end

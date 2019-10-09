require "./abstract_event.cr"
require "./direction.cr"

module Algo::Backtester
  struct SignalEvent < AbstractEvent
    property direction : Direction

    def initialize(@timestamp, @symbol, @direction)
    end
  end
end

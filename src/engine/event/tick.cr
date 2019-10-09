require "../event/abstract_event.cr"
require "../portfolio/metric.cr"

module Algo::Backtester
  struct Tick
    property event : AbstractEvent
    property metric : Metric
    property bid : Float64
    property ask : Float64
    property bid_volume : Float64
    property ask_volume : Float64

    def initialize(@event, @metric, @bid, @ask, @bid_volume, @ask_volume)
    end

    def price
      return (bid + ask) / 2
    end

    def spread
      return (ask - bid)
    end
  end
end

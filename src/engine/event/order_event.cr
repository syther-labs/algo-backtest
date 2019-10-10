require "./abstract_event.cr"
require "./direction.cr"

module Algo::Backtester
  enum OrderType
    Market        = 0
    MarketOnOpen
    MarketOnClose
    StopMarket
    Limit
    StopLimit
  end

  enum OrderStatus
    None            = 0
    New
    Submitted
    PartiallyFilled
    Filled
    Cancelled
    CancelPending
    Invalid
  end

  struct OrderEvent < AbstractEvent
    property direction : Direction
    property id : Int64
    property type : OrderType
    property status : OrderStatus
    property asset_type : String
    property quantity : Int64
    property quantity_filled : Int64?
    property limit_price : Float64?
    property stop_price : Float64?

    def initialize(@id, @symbol, @timestamp, @type, @direction, @status, @asset_type,
                   @quantity, @quantity_filled = nil, @limit_price = nil, @stop_price = nil)
    end

    def cancel
      status = OrderStatus::Cancelled
    end
  end
end

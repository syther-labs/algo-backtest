require "./abstract_event.cr"
require "./direction.cr"

module AlgoBacktester::Event
  # https://ibkr.info/article/255
  enum OrderType
    Market     = 0
    StopMarket
    Limit
    StopLimit
  end

  enum OrderStatus
    Open
    Filled
    Cancelled
    Rejected
    Held
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

    def to_s : String
      return "Order(ts: #{@timestamp.to_s("%Y-%m-%d")}, sym: #{@symbol}, \
      dir: #{@direction}, #: #{@quantity}, type: #{@type})"
    end
  end
end

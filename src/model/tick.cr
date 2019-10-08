require "json"

module Algo::Backtester
    struct Tick
        getter symbol

        JSON.mapping(
            adj_close: { type: Float32, setter: false, key: "adjClose" },
            adj_high: { type: Float32, setter: false, key: "adjHigh" },
            adj_low: { type: Float32, setter: false, key: "adjLow" },
            adj_open: { type: Float32, setter: false, key: "adjOpen" },
            adj_volume: { type: Int32, setter: false, key: "adjVolume" },
            close: { type: Float32, setter: false },
            date: { type: Time, setter: false },
            div_cash: { type: Float32, setter: false, key: "divCash"},
            high: { type: Float32, setter: false },
            low: { type: Float32, setter: false },
            split_factor: { type: Float32, setter: false, key: "splitFactor" },
            volume: { type: Int32, setter: false }
        )
    end
end
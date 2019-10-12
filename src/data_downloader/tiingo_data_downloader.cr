require "halite"
require "json"
require "./abstract_data_downloader.cr"
require "../engine/event/bar.cr"

module Algo::Backtester
  class TiingoDataDownloader < AbstractDataDownloader
    private struct TiingoResponseBar
      JSON.mapping(
        adj_close: {type: Float64, setter: false, key: "adjClose"},
        adj_high: {type: Float64, setter: false, key: "adjHigh"},
        adj_low: {type: Float64, setter: false, key: "adjLow"},
        adj_open: {type: Float64, setter: false, key: "adjOpen"},
        adj_volume: {type: Int64, setter: false, key: "adjVolume"},
        open: {type: Float64, setter: false},
        close: {type: Float64, setter: false},
        timestamp: {type: Time, key: "date"},
        div_cash: {type: Float64, setter: false, key: "divCash"},
        high: {type: Float64, setter: false},
        low: {type: Float64, setter: false},
        split_factor: {type: Float64, setter: false, key: "splitFactor"},
        volume: {type: Int64, setter: false}
      )
    end

    BASE_URL = "https://api.tiingo.com/tiingo/daily"

    # Token word is required when passing as a parameter
    API_KEY = "Token 21106ca2559b22a1ecd1492ed085cdef9f9698e4"

    # Date format used by Tiingo
    DATE_FORMAT = "%Y-%m-%d"

    def query(symbol : String, start_date : Time, end_date : Time)
      url = construct_url(symbol, start_date, end_date)

      response = Halite.get(url, headers: {
        "accept"        => "application/json",
        "Authorization" => API_KEY,
      })
      json = response.parse

      response_bars = Array(TiingoResponseBar).from_json(response.body)

      bars = [] of Bar

      response_bars.each do |rb|
        # Little ugly but none of these attributes can be nil. So we have to initialize
        # every attribute. The reason why we have the intermediary struct is to move
        # the JSON parsing out of the Bar into a temporary private struct.
        bars << Bar.new(timestamp: rb.timestamp, symbol: symbol, adj_close: rb.adj_close,
          adj_high: rb.adj_high, adj_low: rb.adj_low, adj_open: rb.adj_open,
          adj_volume: rb.adj_volume, close: rb.close, div_cash: rb.div_cash, high: rb.high,
          low: rb.low, split_factor: rb.split_factor, volume: rb.volume, open: rb.open)
      end
      return bars
    end

    def query(symbol : String)
      return self.query(symbol, nil, nil)
    end

    private def construct_url(symbol : String, start_date : Time?, end_date : Time?)
      date_params = "" # Append nothing if dates are not present

      if start_date && end_date
        date_params = "?startDate=#{start_date.to_s(DATE_FORMAT)}&endDate=#{end_date.to_s(DATE_FORMAT)}"
      end

      return "#{BASE_URL}/#{symbol}/prices#{date_params}"
    end
  end
end

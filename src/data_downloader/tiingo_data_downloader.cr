require "halite"
require "json"
require "../model/tick.cr"

module Algo::Backtester
    class TiingoDataDownloader
        BASE_URL = "https://api.tiingo.com/tiingo/daily"

        # Token word is required when passing as a parameter
        API_KEY = "Token 21106ca2559b22a1ecd1492ed085cdef9f9698e4"

        # Date format used by Tiingo
        DATE_FORMAT = "%Y-%m-%d"

        def self.query(ticker : String, start_date : Time, end_date : Time)
            url = construct_url(ticker, start_date, end_date)

            response = Halite.get(url, headers: {
                "accept" => "application/json",
                "Authorization" => API_KEY
              })
            
            
            return Array(Tick).from_json(response.body)
        end

        def self.query(ticker : String)
            return self.query(ticker, nil, nil)
        end

        private def self.construct_url(ticker : String, start_date : Time?, end_date : Time?)
            date_params = "" # Append nothing if dates are not present

            if start_date && end_date
                date_params = "?startDate=#{start_date.to_s(DATE_FORMAT)}&endDate=#{end_date.to_s(DATE_FORMAT)}"    
            end
            
            return "#{BASE_URL}/#{ticker}/prices#{date_params}"
        end
    end
end
module Algo::Backtester
abstract class AbstractDataDownloader
    abstract def self.query(ticker : String, start_date : Time, end_date : Time)
    abstract def self.query(ticker : String)
end
end
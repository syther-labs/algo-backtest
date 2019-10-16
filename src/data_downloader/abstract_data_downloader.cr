module AlgoBacktester::DataDownloader
  abstract class AbstractDataDownloader
    abstract def query(symbol : String, start_date : Time, end_date : Time)
    abstract def query(symbol : String)
  end
end

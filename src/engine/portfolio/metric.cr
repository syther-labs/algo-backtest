module Algo::Backtester
  # Metric holds metric propertys to a data point.
  class Metric
    @values = Hash(String, Float64).new

    def add(key : String, value : Float64)
      if key.empty?
        raise Exception.new("invalid key provided")
      end

      @values[key] = value
    end

    def get(key)
      return @values[key]
    end
  end
end

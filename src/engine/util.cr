module Algo::Backtester
  module Stats
    def self.count(collection)
      return collection.size.to_f
    end

    def self.sum(collection)
      return collection.sum
    end

    def self.mean(collection)
      collection.sum / count(collection)
    end

    def self.variance(collection)
      avg = mean(collection)
      mean_squares = collection.map { |el| (el - avg) ** 2 }
      return mean_squares.reduce(&.+) / count(collection)
    end

    def self.stddev(collection)
      Math.sqrt(variance(collection))
    end

    def self.sqrt(num)
      Math.sqrt(num)
    end
  end
end

module Enumerable
  def sum
    return 0 if self.empty?
    return self.reduce(&.+)
  end

  def mean
    return self.sum / self.size.to_f
  end

  def variance
    avg = self.mean
    mean_squares = self.map { |el| (el - avg) ** 2 }
    return mean_squares.reduce(&.+) / self.size
  end

  def stddev
    return Math.sqrt(self.variance)
  end
end

module Algo::Backtester
  abstract class AbstractCommission
    abstract def calculate(quantity : Int64, price : Float64) : Float64
  end
end

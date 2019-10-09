require "./abstract_algorithm.cr"

module Algo::Backtester
  class AlgorithmStack < AbstractAlgorithm
    @stack = [] of AbstractAlgorithm

    def run(strategy : AbstractStrategy)
      @stack.each do |algo|
        unless algo.run(strategy)
          puts "An error occured."
          return false
        end
      end
      return true
    end
  end
end

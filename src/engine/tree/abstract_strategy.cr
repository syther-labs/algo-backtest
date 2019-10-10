module Algo::Backtester
  class AbstractStrategy < AbstractNode
    @algos : AlgorithmStack
    @signals : Array(SignalEvent)

    getter data : DataHandler?
    getter portfolio : AbstractPortfolio?
    property event : AbstractEvent?

    def initialize(name)
      super(name: name, root: true)
      @algos = AlgorithmStack.new
      @signals = [] of SignalEvent
    end

    def data=(data : DataHandler?)
      @data = data
      strategies().each do |strat|
        strat.data = data
      end
    end

    def portfolio=(portfolio : AbstractPortfolio?)
      @portfolio = portfolio
      strategies().each do |strat|
        strat.portfolio = portfolio
      end
    end

    def add_signal(*signals : SignalEvent)
      @signals.concat(signals)
    end

    def set_algo(*algos : AbstractAlgorithm)
      @algos.stack.concat(algos)
    end

    def strategies : Array(AbstractStrategy)
      return @children
        .reject { |c| c.is_a? AbstractStrategy }
        .map {|strat| strat.as(AbstractStrategy)}
    end

    def assets : Array(Asset)
      return @children.select { |c| c.is_a? Asset }
    end

    def on_data(event : Bar) : Array(SignalEvent)
      @event = event

      @algos.run(self)

      # pass event down to child strategies
      strategies().each do |strat|
        child_signals = strat.on_data(event)
        @signals.concat(child_signals)
      end

      signals = @signals

      # Empty this for some reason
      @signals = [] of SignalEvent

      return signals
    end
  end
end

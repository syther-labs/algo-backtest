module AlgoBacktester
  module Event
    abstract struct AbstractEvent
      property timestamp : Time
      property symbol : String

      def initialize(@timestamp : Time, @symbol : String)
      end

      # Force subclasses to override to_s
      abstract def to_s : String
    end
  end
end

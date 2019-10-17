module AlgoBacktester::Tree
  class RunOnceAlgorithm < AbstractAlgorithm
    @has_run : Bool

    # Returns a simple true/false algo
    def initialize(@run_always = false, @value = 0_f64)
      super(@run_always, @value)
      @has_run = false
    end

    # Runs the algorithm, returning the bool value of the algorithm
    def run(strategy : AbstractStrategy) : {Bool, AlgorithmError?}
      return {false, AlgorithmError.new("Run once failed as it has already been run")} if @has_run

      @has_run = true
      return {true, nil}
    end
  end

  abstract class RunPeriodAlgorithm < AbstractAlgorithm
    def initialize(@run_always = false, @value = 0_f64)
      super(@run_always, @value)
    end

    def run(strategy : AbstractStrategy) : {Bool, AlgorithmError?}
      event = strategy.event
      data = strategy.data

      # If we somehow encounter a nil event or nil data (i.e. run without specifying),
      # fail gracefully.
      return {false, AlgorithmError.new("Can't run period algorithm with nil data or nil event")} if event.nil? || data.nil?

      history = data.history

      # If this is the first entry, allow the strategy to run.
      return {true, nil} if history.size <= 1

      now_timestamp = event.timestamp

      event_timestamp = history.first.timestamp

      # So now, we flip this value because we're interested not if the dates are the same, but if we are in a new period.
      same_dates = dates_are_same?(now_timestamp, event_timestamp)
      return {true, nil} if !same_dates
      return {false, AlgorithmError.new("Dates are in same period")}
    end

    abstract def dates_are_same?(now : Time, event : Time)
  end

  class RunDailyAlgorithm < RunPeriodAlgorithm
    def dates_are_same?(now : Time, event : Time)
      return now.day_of_year == event.day_of_year
    end
  end

  class RunWeeklyAlgorithm < RunPeriodAlgorithm
    def dates_are_same?(now : Time, event : Time)
      return now.calendar_week == event.calendar_week
    end
  end

  class RunMonthlyAlgorithm < RunPeriodAlgorithm
    def dates_are_same?(now : Time, event : Time)
      return now.month == event.month && now.year == event.year
    end
  end

  class RunQuarterlyAlgorithm < RunPeriodAlgorithm
    def dates_are_same?(now : Time, event : Time)
      return date_quarter(now) == date_quarter(event) && now.year == event.year
    end

    private def date_quarter(date : Time)
      return case date.month
      when 1..3
        return 1
      when 4..6
        return 2
      when 7..9
        return 3
      when 10..12
        return 4
      else
        raise InvalidParameterError.new
      end
    end
  end

  class RunYearlyAlgorithm < RunPeriodAlgorithm
    def dates_are_same?(now : Time, event : Time)
      puts "now.year == event.year => #{now.to_s("%Y")} == #{now.to_s("%Y")} = #{event.year == now.year}"
      return now.year == event.year
    end
  end
end

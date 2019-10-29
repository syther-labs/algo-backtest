require "../../spec_helper"

describe T::RunOnceAlgorithm do
  it "should return true on the first run" do
    ifa = T::RunOnceAlgorithm.new
    ifa.run(create_strat).should eq({true, nil})
  end

  it "should return false on second+ run" do
    ifa = T::RunOnceAlgorithm.new
    ifa.run(create_strat).should eq({true, nil})
    10.times do
      got = ifa.run(create_strat)
      got[0].should be_false
      got[1].is_a?(Exception).should be_true
    end
  end
end

# Test the abstract class methods
class MockRunPeriodAlgorithm < RunPeriodAlgorithm
  private def dates_are_same?(now, event)
    true
  end
end

describe MockRunPeriodAlgorithm do
  it "should return error if data is nil and/or event is nil" do
    no_data_no_event_strat = create_strat()
    rpa = MockRunPeriodAlgorithm.new
    got1 = rpa.run(create_strat)
    got1[0].should be_false
    got1[1].is_a?(Exception).should be_true

    no_data_strat = create_strat()
    no_data_strat.event = create_fill
    got2 = rpa.run(create_strat)
    got2[0].should be_false
    got2[1].is_a?(Exception).should be_true

    no_event_strat = create_strat()
    no_event_strat.data = AlgoBacktester::DataHandler.new
    got3 = rpa.run(create_strat)
    got3[0].should be_false
    got3[1].is_a?(Exception).should be_true
  end

  it "should allow the strategy to run but exit early if there's only zero or one event" do
    strat = create_strat
    strat.data = AlgoBacktester::DataHandler.new(stream: [create_bar])
    strat.event = create_fill

    rpa = MockRunPeriodAlgorithm.new
    rpa.run(strat).should eq({true, nil})
  end
end

def test_dates_are_same(klass, start_end_pairs : Array(Tuple(Time, Time)))
  results = [] of Tuple(Bool, Exception?)
  start_end_pairs.each do |pair|
    strat = create_strat
    stream = [create_bar, create_bar]
    past_bar = create_bar({timestamp: pair[1]})
    history = [past_bar, create_bar, create_bar]

    strat.data = AlgoBacktester::DataHandler.new(history: history, stream: stream)
    strat.event = create_fill({timestamp: pair[0]})

    algo = klass.new
    results << algo.run(strat)
  end
  return results
end

describe T::RunDailyAlgorithm do
  it "should stop algo (return false) if run on same day" do
    dates = [
      {Time.utc(2019, 3, 30), Time.utc(2019, 3, 30)},
      {Time.utc(2016, 1, 1), Time.utc(2016, 1, 1)},
    ]
    returns = test_dates_are_same(T::RunDailyAlgorithm, dates)
    returns.each do |got|
      got[0].should be_false
      got[1].is_a?(Exception).should be_true
    end
  end
  it "should allow algo to run (return true) if run on different days" do
    dates = [
      {Time.utc(2016, 1, 1), Time.utc(2016, 1, 2)},
      {Time.utc(2016, 1, 1), Time.utc(2017, 1, 1)},
    ]
    returns = test_dates_are_same(T::RunDailyAlgorithm, dates)
    returns.each { |got| got.should eq({true, nil}) }
  end
end

describe T::RunWeeklyAlgorithm do
  # The ISO calendar year to which the week belongs is not always in the same
  # as the year of the regular calendar date. The first three days of January
  # sometimes belong to week 52 (or 53) of the previous year; equally the last
  # three days of December sometimes are already in week 1 of the following year.
  it "should stop algo (return false) if run in same week" do
    dates = [
      {Time.utc(2016, 2, 1), Time.utc(2016, 2, 6)}, # sunday to saturday
      {Time.utc(2016, 2, 1), Time.utc(2016, 2, 1)}, # same day
    ]
    returns = test_dates_are_same(T::RunWeeklyAlgorithm, dates)
    returns.each do |got|
      got[0].should be_false
      got[1].is_a?(Exception).should be_true
    end
  end
  it "should allow algo to run (return true) if run in different weeks" do
    dates = [
      {Time.utc(2016, 2, 1), Time.utc(2016, 2, 9)},
      {Time.utc(2016, 2, 1), Time.utc(2017, 2, 1)},
    ]
    returns = test_dates_are_same(T::RunWeeklyAlgorithm, dates)
    returns.each { |got| got.should eq({true, nil}) }
  end
end

describe T::RunMonthlyAlgorithm do
  it "should stop algo (return false) if run in same month" do
    dates = [
      {Time.utc(2016, 1, 1), Time.utc(2016, 1, 7)},
      {Time.utc(2016, 1, 1), Time.utc(2016, 1, 21)},
      {Time.utc(2016, 1, 1), Time.utc(2016, 1, 1)},
    ]
    returns = test_dates_are_same(T::RunMonthlyAlgorithm, dates)
    returns.each do |got|
      got[0].should be_false
      got[1].is_a?(Exception).should be_true
    end
  end
  it "should allow algo to run (return true) if run in different months" do
    dates = [
      {Time.utc(2016, 1, 1), Time.utc(2016, 2, 1)},
    ]
    returns = test_dates_are_same(T::RunMonthlyAlgorithm, dates)
    returns.each { |got| got.should eq({true, nil}) }
  end
end

describe T::RunQuarterlyAlgorithm do
  it "should stop algo (return false) if run in same quarter" do
    dates = [
      {Time.utc(2016, 1, 1), Time.utc(2016, 1, 7)},
      {Time.utc(2016, 1, 1), Time.utc(2016, 2, 1)},
      {Time.utc(2016, 1, 1), Time.utc(2016, 3, 30)},
    ]
    returns = test_dates_are_same(T::RunQuarterlyAlgorithm, dates)
    returns.each do |got|
      got[0].should be_false
      got[1].is_a?(Exception).should be_true
    end
  end
  it "should allow algo to run (return true) if run in different quarters" do
    dates = [
      {Time.utc(2016, 1, 1), Time.utc(2015, 12, 31)},
      {Time.utc(2016, 1, 1), Time.utc(2016, 5, 1)},
    ]
    returns = test_dates_are_same(T::RunQuarterlyAlgorithm, dates)
    returns.each { |got| got.should eq({true, nil}) }
  end
end

describe T::RunYearlyAlgorithm do
  it "should stop algo (return false) if run in same year" do
    dates = [
      {Time.utc(2016, 1, 1), Time.utc(2016, 1, 7)},
      {Time.utc(2016, 1, 1), Time.utc(2016, 2, 1)},
      {Time.utc(2016, 1, 1), Time.utc(2016, 3, 30)},
      {Time.utc(2016, 1, 1), Time.utc(2016, 12, 31)},
    ]
    returns = test_dates_are_same(T::RunYearlyAlgorithm, dates)
    returns.each do |got|
      got[0].should be_false
      got[1].is_a?(Exception).should be_true
    end
  end
  it "should allow algo to run (return true) if run in different years" do
    dates = [
      {Time.utc(2016, 1, 1), Time.utc(2015, 12, 31)},
      {Time.utc(2016, 1, 1), Time.utc(2019, 1, 1)},
    ]
    returns = test_dates_are_same(T::RunYearlyAlgorithm, dates)
    returns.each { |got| got.should eq({true, nil}) }
  end
end

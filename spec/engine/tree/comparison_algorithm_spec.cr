require "../../spec_helper"

def true_algo(value : Float64?)
  T::BoolAlgorithm.new(true, value: value || 0_f64)
end

def false_algo(value : Float64?)
  T::BoolAlgorithm.new(false, value: value || 0_f64)
end

describe T::GreaterThanAlgorithm do
  it "should return true with no error if first's value is > second's value" do
    bigger = true_algo(2.0_f64)
    smaller = true_algo(1.0_f64)
    ifa = T::GreaterThanAlgorithm.new(bigger, smaller)
    ifa.run(create_strat).should eq({true, nil})
  end

  it "should return false with error if first's value was not > second's value" do
    bigger = true_algo(2.0_f64)
    smaller = true_algo(1.0_f64)
    ifa = T::GreaterThanAlgorithm.new(smaller, bigger)
    got = ifa.run(create_strat)
    got[0].should be_false
    got[1].is_a?(Exception).should be_true
  end

  it "should return false with error if first or second algo doesn't return true" do
    bigger_true = true_algo(2.0_f64)
    smaller_false = false_algo(1.0_f64)
    ifa = T::GreaterThanAlgorithm.new(bigger_true, smaller_false)
    got = ifa.run(create_strat)
    got[0].should be_false
    got[1].is_a?(Exception).should be_true

    bigger_false = false_algo(2.0_f64)
    smaller_true = true_algo(1.0_f64)
    ifb = T::GreaterThanAlgorithm.new(bigger_false, smaller_true)
    got = ifb.run(create_strat)
    got[0].should be_false
    got[1].is_a?(Exception).should be_true
  end
end

describe T::LessThanAlgorithm do
  it "should return true with no error if first's value is < second's value" do
    bigger = true_algo(2.0_f64)
    smaller = true_algo(1.0_f64)
    ifa = T::LessThanAlgorithm.new(smaller, bigger)
    ifa.run(create_strat).should eq({true, nil})
  end

  it "should return false with error if first's value was not < second's value" do
    bigger = true_algo(2.0_f64)
    smaller = true_algo(1.0_f64)
    ifa = T::LessThanAlgorithm.new(bigger, smaller)
    got = ifa.run(create_strat)
    got[0].should be_false
    got[1].is_a?(Exception).should be_true
  end

  it "should return false with error if first or second algo doesn't return true" do
    bigger_true = true_algo(2.0_f64)
    smaller_false = false_algo(1.0_f64)
    ifa = T::LessThanAlgorithm.new(bigger_true, smaller_false)
    got = ifa.run(create_strat)
    got[0].should be_false
    got[1].is_a?(Exception).should be_true

    bigger_false = false_algo(2.0_f64)
    smaller_true = true_algo(1.0_f64)
    ifb = T::LessThanAlgorithm.new(bigger_false, smaller_true)
    got = ifb.run(create_strat)
    got[0].should be_false
    got[1].is_a?(Exception).should be_true
  end
end

describe T::EqualToAlgorithm do
  it "should return true with no error if first's value is == second's value" do
    first = true_algo(1.0_f64)
    second = true_algo(1.0_f64)
    ifa = T::EqualToAlgorithm.new(first, second)
    ifa.run(create_strat).should eq({true, nil})
  end

  it "should return false with error if first's value was not == second's value" do
    first = true_algo(100.0_f64)
    second = true_algo(1.0_f64)
    ifa = T::EqualToAlgorithm.new(second, first)
    got = ifa.run(create_strat)
    got[0].should be_false
    got[1].is_a?(Exception).should be_true
  end

  it "should return false with error if first or second algo doesn't return true" do
    first_true = true_algo(1.0_f64)
    second_false = false_algo(1.0_f64)
    ifa = T::EqualToAlgorithm.new(first_true, second_false)
    got = ifa.run(create_strat)
    got[0].should be_false
    got[1].is_a?(Exception).should be_true

    first_false = false_algo(1.0_f64)
    second_true = true_algo(1.0_f64)
    ifb = T::EqualToAlgorithm.new(first_false, second_true)
    got = ifb.run(create_strat)
    got[0].should be_false
    got[1].is_a?(Exception).should be_true
  end
end

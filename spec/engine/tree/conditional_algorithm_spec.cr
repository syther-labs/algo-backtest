require "../../spec_helper"

def true_algo
  T::BoolAlgorithm.new(true)
end

def false_algo
  T::BoolAlgorithm.new(false)
end

describe T::IfAlgorithm do
  it "should return true with no error, if condition and action are true" do
    ifa = T::IfAlgorithm.new(true_algo, true_algo)
    ifa.run(create_strat).should eq({true, nil})
  end

  it "should return false, with error if condition is true but action was false" do
    ifa = T::IfAlgorithm.new(true_algo, false_algo)
    got = ifa.run(create_strat)
    got[0].should be_false
    got[1].is_a?(Exception).should be_true
  end

  it "should return true with no error if condition is false and action is true/false" do
    immaterial_actions = [false_algo, true_algo]
    immaterial_actions.each do |action|
      ifa = T::IfAlgorithm.new(false_algo, action)
      ifa.run(create_strat).should eq({true, nil})
    end
  end
end

describe T::AndAlgorithm do
  it "should return true with no error, if first and second are true" do
    ifa = T::AndAlgorithm.new(true_algo, true_algo)
    ifa.run(create_strat).should eq({true, nil})
  end

  it "should return false, with error if first is true and second is false" do
    ifa = T::AndAlgorithm.new(true_algo, false_algo)
    got = ifa.run(create_strat)
    got[0].should be_false
    got[1].is_a?(Exception).should be_true
  end

  it "should return false, with error if first is false and second is true" do
    ifa = T::AndAlgorithm.new(false_algo, true_algo)
    got = ifa.run(create_strat)
    got[0].should be_false
    got[1].is_a?(Exception).should be_true
  end

  it "should return false with error if first is false and second is false" do
    ifa = T::AndAlgorithm.new(false_algo, false_algo)
    got = ifa.run(create_strat)
    got[0].should be_false
    got[1].is_a?(Exception).should be_true
  end
end

describe T::OrAlgorithm do
  it "should return true with no error, if first and second are true" do
    ifa = T::OrAlgorithm.new(true_algo, true_algo)
    ifa.run(create_strat).should eq({true, nil})
  end

  it "should return true with no error if first is true and second is false" do
    ifa = T::OrAlgorithm.new(true_algo, false_algo)
    ifa.run(create_strat).should eq({true, nil})
  end

  it "should return true with no error if first is false and second is true" do
    ifa = T::OrAlgorithm.new(false_algo, true_algo)
    ifa.run(create_strat).should eq({true, nil})
  end

  it "should return false with error if first is false and second is false" do
    ifa = T::OrAlgorithm.new(false_algo, false_algo)
    got = ifa.run(create_strat)
    got[0].should be_false
    got[1].is_a?(Exception).should be_true
  end
end

describe T::XorAlgorithm do
  it "should return false with error if first and second are true" do
    ifa = T::XorAlgorithm.new(true_algo, true_algo)
    got = ifa.run(create_strat)
    got[0].should be_false
    got[1].is_a?(Exception).should be_true
  end

  it "should return true with no error if first is true and second is false" do
    ifa = T::XorAlgorithm.new(true_algo, false_algo)
    ifa.run(create_strat).should eq({true, nil})
  end

  it "should return true with no error if first is false and second is true" do
    ifa = T::XorAlgorithm.new(false_algo, true_algo)
    ifa.run(create_strat).should eq({true, nil})
  end

  it "should return false with error if first is false and second is false" do
    ifa = T::XorAlgorithm.new(false_algo, false_algo)
    got = ifa.run(create_strat)
    got[0].should be_false
    got[1].is_a?(Exception).should be_true
  end
end

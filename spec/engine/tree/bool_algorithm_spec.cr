require "../../spec_helper"

def strat
  Strategy.new("this-is-a-test")
end

describe T::BoolAlgorithm do
  it "a true algo should always return true" do
    ifa = T::BoolAlgorithm.new(true)
    ifa.run(strat).should eq({true, nil})
  end

  it "a false algo should always return false" do
    ifa = T::BoolAlgorithm.new(false)
    got = ifa.run(strat)
    got[0].should be_false
    got[1].is_a?(Exception).should be_true
  end
end

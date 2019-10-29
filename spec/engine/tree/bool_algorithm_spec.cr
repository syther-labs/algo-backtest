require "../../spec_helper"

describe T::BoolAlgorithm do
  it "a true algo should always return true" do
    ifa = T::BoolAlgorithm.new(true)
    ifa.run(create_strat).should eq({true, nil})
  end

  it "a false algo should always return false" do
    ifa = T::BoolAlgorithm.new(false)
    got = ifa.run(create_strat)
    got[0].should be_false
    got[1].is_a?(Exception).should be_true
  end
end

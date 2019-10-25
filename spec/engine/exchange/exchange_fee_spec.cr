require "../../spec_helper"

describe SE::FixedExchangeFee do
  it "should return the initialized fee if positive" do
    fee = SE::FixedExchangeFee.new(100_f64)
    fee.fee.should eq(100_i64)
  end

  it "should throw an error if fee negative" do
    # We can update this if we ever want to implement a maker-taker model
    expect_raises Exception do
      fee = SE::FixedExchangeFee.new(-100_f64)
    end
  end
end

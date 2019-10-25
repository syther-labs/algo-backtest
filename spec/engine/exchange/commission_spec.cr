require "../../spec_helper"

describe SE::FixedCommission do
  it "should return 0 if quantity is 0 or price is 0" do
    fc = SE::FixedCommission.new(100_f64)
    fc.calculate(0_i64, 1_f64).should eq(0_f64)
    fc.calculate(1_i64, 0_f64).should eq(0_f64)
  end

  it "should return commission otherwise" do
    fc = SE::FixedCommission.new(100_f64)
    fc.calculate(1_i64, 1_f64).should eq(100_f64)
  end
end

describe SE::PercentageCommission do
  it "should return 0 if quantity is 0 or price is 0" do
    fc = SE::PercentageCommission.new(0.5_f64)
    fc.calculate(0_i64, 1_f64).should eq(0_f64)
    fc.calculate(1_i64, 0_f64).should eq(0_f64)
  end
  it "should raise error if percentage is perc < 0 or > 100" do
    expect_raises Exception do
      SE::PercentageCommission.new(101_f64)
    end
    expect_raises Exception do
      SE::PercentageCommission.new(-1_f64)
    end
  end
  it "should return % if quantity and price > 0" do
    fc = SE::PercentageCommission.new(0.3_f64)
    fc.calculate(1_i64, 1_f64).should eq(0.3_f64)
  end
end
describe SE::ThresholdFixedCommission do
  it "should return 0 if quantity is 0 or price is 0" do
    rc = SE::ThresholdFixedCommission.new(0.5_f64, 50_f64)
    rc.calculate(0_i64, 1_f64).should eq(0_f64)
    rc.calculate(1_i64, 0_f64).should eq(0_f64)
  end
  it "should raise error if commission is perc < 0 or > 100" do
    expect_raises Exception do
      SE::ThresholdFixedCommission.new(-1_f64, 50_f64)
    end
  end
  it "should raise error if min commission is < 0" do
    expect_raises Exception do
      SE::ThresholdFixedCommission.new(0.5_f64, -50_f64)
    end
  end
  it "should return min commission if commission < min commission" do
    rc = SE::ThresholdFixedCommission.new(0.5, 5_f64)
    rc.calculate(1_i64, 1_f64).should eq(5_f64)
  end
  it "should return commission if > min" do
    rc = SE::ThresholdFixedCommission.new(0.5_f64, 0_f64)
    rc.calculate(3_i64, 1_f64).should eq(0.5_f64)
  end
end
describe SE::RangeCommission do
  it "should return 0 if quantity is 0 or price is 0" do
    rc = SE::RangeCommission.new(0.5_f64, 50_f64, 100_f64)
    rc.calculate(0_i64, 1_f64).should eq(0_f64)
    rc.calculate(1_i64, 0_f64).should eq(0_f64)
  end
  it "should raise error if percentage is perc < 0 or > 100" do
    expect_raises Exception do
      SE::RangeCommission.new(-1_f64, 50_f64, 100_f64)
    end
    expect_raises Exception do
      SE::RangeCommission.new(1.1_f64, 50_f64, 100_f64)
    end
  end
  it "should raise error if min/max commission is < 0" do
    expect_raises Exception do
      SE::RangeCommission.new(0.5_f64, -50_f64, 100_f64)
    end
    expect_raises Exception do
      SE::RangeCommission.new(0.5_f64, 50_f64, -100_f64)
    end
  end
  it "should raise error if max commission < min commission" do
    expect_raises Exception do
      SE::RangeCommission.new(0.5_f64, 100_f64, 50_f64)
    end
  end
  it "should return min commission if commission < min commission" do
    rc = SE::RangeCommission.new(0.5, 5_f64, 6_f64)
    rc.calculate(1_i64, 1_f64).should eq(5_f64)
  end
  it "should return max commission if commission > max commission" do
    rc = SE::RangeCommission.new(1_f64, 1_f64, 2_f64)
    rc.calculate(3_i64, 1_f64).should eq(2_f64)
  end
  it "should return commission if between min and max" do
    rc = SE::RangeCommission.new(0.5_f64, 1_f64, 2_f64)
    rc.calculate(3_i64, 1_f64).should eq(1.5_f64)
  end
end

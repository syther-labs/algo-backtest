require "../../spec_helper"

describe T::IsInvestedAlgorithm do
  it "should return true and nil if is invested" do
    # create filled portfolio
    port = create_portfolio
    dh = AB::DataHandler.new
    fill = create_fill({direction: AB::Event::Direction::Buy})
    port.on_fill(fill, dh)

    # create strategy with event and portfolio
    strat = create_strat()
    strat.portfolio = port
    strat.event = create_fill()

    algo = T::IsInvestedAlgorithm.new(["AAPL"])
    algo.run(strat).should eq({true, nil})
  end

  it "should return false and error if not invested" do
    # create filled portfolio
    port = create_portfolio
    dh = AB::DataHandler.new
    fill = create_fill({direction: AB::Event::Direction::Buy})
    port.on_fill(fill, dh)

    # create strategy with event and portfolio
    strat = create_strat()
    strat.portfolio = port
    strat.event = create_fill()

    algo = T::IsInvestedAlgorithm.new(["BANANA"])
    got = algo.run(strat)
    got[0].should eq(false)
    got[1].is_a?(Exception).should eq(true)
  end

  it "should return false and error if portfolio is nil" do
    strat = create_strat()
    strat.event = create_fill()

    algo = T::IsInvestedAlgorithm.new(["BANANA"])
    got = algo.run(strat)
    got[0].should eq(false)
    got[1].is_a?(Exception).should eq(true)
  end

  it "should return false and error if event is nil" do
    # create filled portfolio
    port = create_portfolio
    dh = AB::DataHandler.new
    fill = create_fill({direction: AB::Event::Direction::Buy})
    port.on_fill(fill, dh)

    strat = create_strat()

    algo = T::IsInvestedAlgorithm.new(["BANANA"])
    got = algo.run(strat)
    got[0].should eq(false)
    got[1].is_a?(Exception).should eq(true)
  end
end

describe T::IsNotInvestedAlgorithm do
  it "should return false and error if is invested" do
    # create filled portfolio
    port = create_portfolio
    dh = AB::DataHandler.new
    fill = create_fill({direction: AB::Event::Direction::Buy})
    port.on_fill(fill, dh)

    # create strategy with event and portfolio
    strat = create_strat()
    strat.portfolio = port
    strat.event = create_fill()

    algo = T::IsNotInvestedAlgorithm.new(["AAPL"])
    got = algo.run(strat)
    got[0].should eq(false)
    got[1].is_a?(Exception).should eq(true)
  end

  it "should return true and nil if not invested" do
    # create filled portfolio
    port = create_portfolio
    dh = AB::DataHandler.new
    fill = create_fill({direction: AB::Event::Direction::Buy})
    port.on_fill(fill, dh)

    # create strategy with event and portfolio
    strat = create_strat()
    strat.portfolio = port
    strat.event = create_fill()

    algo = T::IsNotInvestedAlgorithm.new(["BANANA"])
    algo.run(strat).should eq({true, nil})
  end

  it "should return false and error if portfolio is nil" do
    strat = create_strat()
    strat.event = create_fill()

    algo = T::IsNotInvestedAlgorithm.new(["BANANA"])
    got = algo.run(strat)
    got[0].should eq(false)
    got[1].is_a?(Exception).should eq(true)
  end

  it "should return false and error if event is nil" do
    # create filled portfolio
    port = create_portfolio
    dh = AB::DataHandler.new
    fill = create_fill({direction: AB::Event::Direction::Buy})
    port.on_fill(fill, dh)

    strat = create_strat()

    algo = T::IsNotInvestedAlgorithm.new(["BANANA"])
    got = algo.run(strat)
    got[0].should eq(false)
    got[1].is_a?(Exception).should eq(true)
  end
end

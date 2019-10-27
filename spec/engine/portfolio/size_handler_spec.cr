require "../../spec_helper"

describe AB::SizeHandler do
  describe "#initialize" do
    it "should throw error if invalid size or invalid value" do
      sizes = [
        {0_i64, 1_f64},  # default size = 0, default value valid
        {1_i64, 0_f64},  # default size valid, default value invalid
        {-1_i64, 1_f64}, # default size invalid (neg), default value valid
        {1_i64, -1_f64}, # default size valid, default value invalid (neg)
      ] of Tuple(Int64, Float64)

      sizes.each do |pair|
        expect_raises Exception do
          AB::SizeHandler.new(pair[0], pair[1])
        end
      end
    end
  end

  describe "#size_order" do
    context "when size is corrected" do
      it "should size buy and sell orders" do
        directions = [AB::Event::Direction::Buy, AB::Event::Direction::Sell]
        directions.each do |dir|
          # Default size: 100, default_value: 1000
          sh = create_order_sizer()
          # This will make the default_size (100) * price (11) > default_value (1000)
          # 100 * 11 = 1100 > 1000
          bar = create_bar({close: 11_f64})
          # So, now we use the corrected quantity conditional
          port = create_portfolio()
          unsized_order = create_order({direction: dir})
          sized_order = sh.size_order(unsized_order, bar, port)
          expected_size = 90_i64 # floor(default value / price)
          sized_order.quantity.should eq(expected_size)
        end
      end
    end # context
    context "when size is reset to default size" do
      it "should size buy and sell orders" do
        directions = [AB::Event::Direction::Buy, AB::Event::Direction::Sell]
        directions.each do |dir|
          # Default size: 100, default_value: 1000
          sh = create_order_sizer()
          # This will make the default_size (100) * price (9) < default_value (1000)
          # 100 * 9 = 900 < 1000
          bar = create_bar({close: 9_f64})
          # So, now we use the corrected quantity conditional
          port = create_portfolio()
          unsized_order = create_order({direction: dir})
          sized_order = sh.size_order(unsized_order, bar, port)
          expected_size = 100 # default_size
          sized_order.quantity.should eq(expected_size)
        end # each
      end   # it
    end     # context

    context "when exiting from existing positions" do
      it "should throw an error if attempting to exit from a position which doesn't exist" do
        # Default size: 100, default_value: 1000
        sh = create_order_sizer()
        # This will make the default_size (100) * price (9) < default_value (1000)
        # 100 * 9 = 900 < 1000
        bar = create_bar({close: 9_f64})
        # So, now we use the corrected quantity conditional
        port = create_portfolio()
        unsized_order = create_order({direction: AB::Event::Direction::Exit})
        expect_raises Exception do
          sh.size_order(unsized_order, bar, port)
        end
      end

      it "should exit from a long position" do
        # Default size: 100, default_value: 1000
        sh = create_order_sizer()
        bar = create_bar({close: 1_f64})
        # So, now we use the corrected quantity conditional
        port = create_portfolio()
        fill = create_fill({direction: AB::Event::Direction::Buy})
        dh = AB::DataHandler.new
        port.on_fill(fill, dh)
        unsized_order = create_order({direction: AB::Event::Direction::Exit})
        sized_order = sh.size_order(unsized_order, bar, port)
        # We shouldn't need to size the order other than just exit from the
        # entire position.
        sized_order.quantity.should eq(fill.quantity)
      end
      it "should exit from a short position" do
        # Default size: 100, default_value: 1000
        sh = create_order_sizer()
        bar = create_bar({close: 1_f64})
        # So, now we use the corrected quantity conditional
        port = create_portfolio()
        fill = create_fill({
          quantity:  -10_i64,
          direction: AB::Event::Direction::Sell,
        })
        dh = AB::DataHandler.new
        port.on_fill(fill, dh)
        unsized_order = create_order({direction: AB::Event::Direction::Exit})
        sized_order = sh.size_order(unsized_order, bar, port)
        # We shouldn't need to size the order other than just exit from the
        # entire position.
        sized_order.quantity.should eq(-1 * fill.quantity)
      end
    end
  end # describe method
end   # describe class

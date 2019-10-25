require "../../spec_helper"

# We create this class to test the abstract node properties
class MockNode < T::AbstractNode; end

describe T::AbstractNode do
  describe "#name" do
    it "should return the name of the node" do
      node = MockNode.new(name: "sample-node-name")
      node.name.should eq("sample-node-name")
    end
  end

  describe "#root" do
    it "should return if the node is the root node" do
      is_root = MockNode.new(name: "parent", root: true)
      is_child = MockNode.new(name: "child", root: false)
      is_root.root.should be_true
      is_child.root.should be_false
    end
    it "should have a setter to modify the root property" do
      node = MockNode.new(name: "foo", root: false)
      node.root.should be_false
      # Then we apply the property
      node.root = true
      node.root.should be_true
    end
  end
  pending "to test children"
end

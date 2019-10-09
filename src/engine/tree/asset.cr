require "./abstract_node.cr"

module Algo::Backtester
  class Asset < AbstractNode
    def initialize(@name : String)
      super
      @root = false
    end

    # Children returns an empty slice and false, an Asset is not allowed to have children.
    def children
      return [] of AbstractNode
    end

    # SetChildren return itself without change, as an Asset ist not allowed to have children.
    def set_children(*children : AbstractNode)
      nil
    end
  end
end

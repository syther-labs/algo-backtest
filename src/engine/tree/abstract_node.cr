module Algo::Backtester
  abstract class AbstractNode
    getter name : String
    property root : Bool
    property weight : Float64
    property tolerance : Float64
    @children = [] of AbstractNode

    def initialize(@name, @root = false, @weight = 1.0, @tolerance = 0.0)
    end

    def add_child(child : AbstractNode)
      child.root = false
      @children << child
    end

    def set_children(*children : AbstractNode)
      children.each { |c| add_child(c) }
    end

    def is_root?
      root
    end
  end
end

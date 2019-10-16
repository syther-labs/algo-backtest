module AlgoBacktester
  module Exception
    # Generic error
    class Error < ::Exception; end

    # Operation called on empty data handler
    class EmptyDataHandlerError < Error; end

    # The direction cannot be understood
    class UnsupportedDirectionError < Error; end

    # A generic error for invalid parameters
    class InvalidParameterError < Error; end

    # Operation called on holding that does not exist
    class HoldingDoesNotExistError < Error; end

    # An error ocurred during the run of the algorithms
    class AlgorithmError < Error; end
  end

  {% for cls in Exception.constants %}
    # :nodoc:
    alias {{ cls.id }} = Exception::{{ cls.id }}
  {% end %}
end

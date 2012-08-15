class TestHarness
  class UIComponent
    class << self
      def component
        @c ||= OpenStruct.new
        yield @c if block_given?
        @c
      end
    end
  end
end

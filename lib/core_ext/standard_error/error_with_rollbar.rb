module CoreExt
  module StandardError
    module ErrorWithRollbar
      def initialize
        p 'some test hello'
        # super
      end
    end
  end
end

# StandardError.singleton_class.send(:prepend, CoreExt::StandardError::ErrorWithRollbar)

module CoreExt
  module String
    module Boolean
      def to_bool
        ActiveModel::Type::Boolean.new.cast(self.downcase)
      end
    end
  end
end

String.send(:include, CoreExt::String::Boolean)

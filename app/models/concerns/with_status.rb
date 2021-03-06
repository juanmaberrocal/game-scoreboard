# frozen_string_literal: true

# Concern used to add necessary functionality to models
# that have a `*_result` column(s)
# Adds validation for column
#   to ensure status can only change in certain direction
# Adds enum for column
module WithStatus
  extend ActiveSupport::Concern

  STATUSES = {
    pending: 'pending',
    confirmed: 'confirmed',
    rejected: 'rejected'
  }.freeze

  included do
    %i[match_status result_status].each do |column|
      next unless column_names.include?(column.to_s)

      validates_each column,
                     on: :update,
                     if: :"#{column}_changed?" do |record, attr, _value|
        old_status = record.send(:"#{column}_was").to_sym
        new_status = record.send(column).to_sym

        # Status change can only occur in a specific direction
        # pending => confirmed
        # pending => rejected
        # Status cannot be changed back to pending
        # Status cannot be changed to any value not part of ::STATUSES
        case new_status
        when :confirmed, :rejected
          unless old_status == :pending
            record.errors
                  .add(attr,
                       'cannot be updated from '\
                       "`#{old_status}` to `#{new_status}`")
          end
        else
          record.errors
                .add(attr, "cannot be updated to `#{new_status}`")
        end
      end

      enum column => STATUSES
    end
  end
end

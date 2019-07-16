class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.random(count, column = nil)
    records = self.all
    records = records.pluck(column.to_sym) if column.present?
    records = records.sample(count)
    records
  end
end

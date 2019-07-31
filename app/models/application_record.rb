class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.random(count = 1)
    records = self.all
    records = records.sample(count)
    records
  end

  def self.similar(column, value)
    records = self.all
    records = records.where("#{column} ILIKE ?", "%#{value.gsub(/\s+/, '%')}%")
    records
  end
end

# frozen_string_literal: true

class StatisticsSerializer < FastJsonapiSerializer
  attributes :statistics

  meta do |record|
    {
      record_class: record.class.name,
      record_id: record.id
    }
  end
end

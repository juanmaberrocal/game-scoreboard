class StandingsSerializer < FastJsonapiSerializer
  attributes :standings

  meta do |record|
    {
      record_class: record.class.name,
      record_id: record.id
    }
  end
end

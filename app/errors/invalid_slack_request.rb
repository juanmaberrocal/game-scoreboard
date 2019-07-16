class InvalidSlackRequest < StandardError
  def message
    'Unauthorized! Ensure credential errors are fixed.'
  end
end

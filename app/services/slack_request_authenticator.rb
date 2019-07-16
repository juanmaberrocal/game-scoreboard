class SlackRequestAuthenticator
  attr_reader :signature, :timestamp, :body, :version,
              :is_valid

  def initialize(signature, timestamp, body, version = 'v0')
    self.signature = signature
    self.timestamp = timestamp
    self.body      = body
    self.version   = version
  end

  def authenticate
    self.is_valid = authenticate_timestamp &&
                    authenticate_body
  end

  def authenticate!
    authenticate || invalid!
  end

  private

  HASH_SECRET = ENV['SLACK_SIGNING_SECRET'].freeze
  HASH_DIGEST = 'SHA256'.freeze

  def signature=(s)
    @signature = s.to_s
  end

  def timestamp=(t)
    @timestamp = t.to_i
  end

  def body=(b)
    @body = b.to_s
  end

  def version=(v)
    @version = v.to_s
  end

  def is_valid=(v)
    @is_valid = v.present?
  end

  def authenticate_timestamp
    # The request timestamp is more than five minutes from local time.
    # It could be a replay attack, so let's ignore it.
    (Time.now.to_i - timestamp).abs < (60 * 5)
  end

  def authenticate_body
    sig_basestring = "#{version}:#{timestamp}:#{body}"
    sig_hexdigest  = "#{version}=#{OpenSSL::HMAC.hexdigest(HASH_DIGEST, HASH_SECRET, sig_basestring)}"
    sig_hexdigest == signature
  end

  def invalid!
    raise InvalidSlackRequest.new
  end
end

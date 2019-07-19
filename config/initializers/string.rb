class String
  def to_bool
    %w[
      true
      yes
      1
    ].include?(self.downcase)
  end
end

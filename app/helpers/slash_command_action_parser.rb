class SlashCommandActionParser
  include SlashCommandRegex

  attr_reader :text,
              :action, :model, :params

  def initialize(text)
    @text = text
  end

  def parse
    @action, @model, @params = text.match(ACTION_REGEX).try(:captures).try(:map, &:strip)
  end
end

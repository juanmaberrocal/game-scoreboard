class SlashCommandValidator
  include SlashCommandRegex

  attr_reader :command, :action,
              :is_valid

  def initialize(command, action)
    self.command = command
    self.action  = action
  end

  def validate
    self.is_valid = validate_command &&
                    validate_action
  end

  def validate!
    validate || invalid!
  end

  private

  def command=(c)
    @command = c.to_s
  end

  def action=(a)
    @action = a.to_s
  end

  def is_valid=(v)
    @is_valid = v.present?
  end

  def validate_command
    COMMAND_REGEX =~ command
  end

  def validate_action
    ACTION_REGEX =~ action
  end

  def invalid!
    raise InvalidSlashCommand.new("#{command} #{action}")
  end
end

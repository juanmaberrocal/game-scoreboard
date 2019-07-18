class SlashCommandValidator
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

  COMMAND = 'game-scoreboard'.freeze
  ACTION  = 'view|add'.freeze
  MODEL   = 'game|player|match'.freeze
  PARAMS  = '.+'.freeze

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
    %r{^\/#{COMMAND}$}i =~ command
  end

  def validate_action
    %r{^(#{ACTION}):(#{MODEL}) .+$}i =~ action
  end

  def invalid!
    raise InvalidSlashCommand.new("#{command} #{action}")
  end
end

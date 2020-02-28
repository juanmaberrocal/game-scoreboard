class SlashCommandActionServicePicker
  attr_reader :action, :model

  def initialize(action, model)
    @action = action
    @model = model
  end

  def select(params)
    service_string = "#{SLASH_COMMAND_ACTIONS_PREFIX}"\
                     "#{model}_#{action}"\
                     "#{SLASH_COMMAND_ACTIONS_SUFIX}".classify
    service_klass  = service_string.constantize

    service = service_klass.new(params)
  rescue => e
    raise InvalidSlashCommand.new("#{action}:#{model} #{params}")
  end

  private

  SLASH_COMMAND_ACTIONS_PREFIX = 'slash_command_actions/'.freeze
  SLASH_COMMAND_ACTIONS_SUFIX = '_service'.freeze
end

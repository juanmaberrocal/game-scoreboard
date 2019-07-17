class InvalidSlashCommand < StandardError
  attr_reader :command

  def initialize(command)
    @command = command
    super()
  end

  def message
    "Sorry, I don\'t undestand `#{command}`. Please try again."
  end
end

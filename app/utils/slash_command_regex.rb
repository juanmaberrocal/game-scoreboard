module SlashCommandRegex
  extend ActiveSupport::Concern

  private

  COMMAND = 'game-scoreboard'.freeze
  COMMAND_REGEX = %r{^\/#{COMMAND}$}i.freeze

  ACTION  = 'view|add'.freeze
  MODEL   = 'games?|players?|match'.freeze
  PARAMS  = '.+'.freeze
  ACTION_REGEX = %r{^(#{ACTION}):(#{MODEL})((?:\s+|\n)#{PARAMS})?$}im.freeze
end

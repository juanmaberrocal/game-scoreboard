class SlashCommandResponseJob < ApplicationJob
  queue_as :default

  def perform(*args)
    SlashCommandService.new(*args)
                       .perform
  end
end

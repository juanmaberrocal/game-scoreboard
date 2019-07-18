module SlashCommandActions
  class PlayerViewService
    def initialize(player_name)
      player = player_name
    end

    private

    def player=(name)
      @player = Player.find_by_name(player_name)
    end
  end
end

module SlashCommandActions
  class MatchAddService < AddService
    attr_reader :game, :players

    private

    KLASS = 'Match'.freeze

    def build_record
      @game    = Game.find_by_name(record_params.delete(:game))
      @results = {}.tap do |results|
        record_params.each do |player_name, is_winner|
          player = Player.find_by_name(player_name)
          next unless player.present?

          results[player.id] = is_winner.to_bool
        end
      end

      @record = if @game.present? && (@results.keys.length == record_params.length)
                  Match.initialize_with_results(@game.id, @results)
                else
                  nil
                end
    end

    def yes_response_block_text(key, value)
      "*#{key}:* "\
      "#{key.to_s == 'id' ? value : value.to_bool}"
    end
  end
end

module SlashCommandActions
  class MatchAddService < AddService
    attr_reader :game, :players

    private

    KLASS = 'Match'.freeze

    def build_record
      @game    = record_params.delete(:game)
      @players = [].tap do |players|
                   record_params.each do |player, is_winner|
                     players << { player => is_winner }
                   end
                 end

      @record = Match.initialize_with_results(game, players)
    end

    def yes_response_block_text(key, value)
      "*#{key}:* "\
      "#{key.to_s == 'id' ? value : value.to_bool}"
    end
  end
end

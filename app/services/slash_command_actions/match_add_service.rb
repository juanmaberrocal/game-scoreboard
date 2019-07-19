module SlashCommandActions
  class MatchAddService < AddService
    attr_reader :game

    private

    KLASS = 'Match'.freeze

    def build_record
      @game   = record_params.delete(:game)
      @record = Match.initialize_with_results(game, Array.wrap(record_params))
    end

    def yes_response_block_text(key, value)
      "*#{key}:* "\
      "#{key.to_s == 'id' ? value : value.to_bool}"
    end
  end
end

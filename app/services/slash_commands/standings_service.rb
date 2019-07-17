module SlashCommands
  class StandingsService < SlashCommandService
    attr_reader :standings

    private

    def build_response
      if standings.present?
        yes_response
      else
        no_response
      end
    end

    def yes_response
      yes_response_text
      yes_response_blocks
    end

    def yes_response_text; end

    def yes_response_blocks
      standings.each do |standing|
        yes_response_block(standing)
      end
    end

    def yes_response_block(standing)
      @blocks << {
        type: 'section',
        text: {
          type: 'mrkdwn',
          text: yes_response_block_text(standing)
        }
      }
    end

    def yes_response_block_text(standing)
      "*#{standing[:position]}.* "\
      "#{standing[:name]} "\
      "_(#{standing[:num_won]})_"
    end

    def no_response
      no_response_text
    end

    def no_response_text; end
  end
end

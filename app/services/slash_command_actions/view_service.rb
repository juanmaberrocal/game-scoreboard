module SlashCommandActions
  class ViewService < SlashCommandActionService
    attr_reader :record,
                :standings

    def initialize(record_search)
      super()
      self.record = record_search
    end

    def fetch_response
      if record.present?
        fetch_standings
        super()
      else
        build_help_response
      end
    end

    private

    def record=(value); end

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

    def build_help_response
      help_response
    end

    def help_response
      help_response_block
    end

    def help_response_block
      @blocks << {
        type: 'section',
        text: {
          type: 'mrkdwn',
          text: help_response_block_text
        }
      }
    end

    def help_response_block_text; end

    def build_body
      {}.tap do |body|
        body[:response_type] = 'ephemeral' if blocks.present? &&
                                              record.blank?
      end.merge(super)
    end
  end
end

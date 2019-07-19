module SlashCommandActions
  class AddService < SlashCommandActionService
    attr_reader :klass, :record_params,
                :record

    def initialize(record_params)
      super()
      self.klass         = self.class::KLASS
      self.record_params = record_params
    end

    def fetch_response
      build_record
      super if record.present? &&
               record.save
    end

    private

    KLASS = ''.freeze

    def klass=(value);
      @klass = value.constantize
    end

    def record_params=(record_params)
      params = parse_record_params(record_params)
      @record_params = build_record_params(params)
    end

    def parse_record_params(record_params)
      record_params.split(/\s?\n+\s?/)
                   .try(:compact)
    end

    def build_record_params(record_params)
      {}.tap do |record_param|
        record_params.each do |r_param|
          key, value = r_param.split(':')
                              .try(:map, &:strip)
          record_param[key.to_sym] = value
        end
      end
    end

    def build_record
      @record = klass.new(record_params)
    end

    def build_response
      yes_response
    end

    def yes_response
      yes_response_text
      yes_response_blocks
    end

    def yes_response_text
      @blocks << {
        type: 'section',
        text: {
          type: 'mrkdwn',
          text: "Awesome, a new `#{self.class::KLASS}` record has been created! "\
                "Here are the details:"
        }
      }
    end

    def yes_response_blocks
      {
        id: record.id
      }.merge(record_params).each do |key, value|
        yes_response_block(key, value)
      end
    end

    def yes_response_block(key, value)
      @blocks << {
        type: 'section',
        text: {
          type: 'mrkdwn',
          text: yes_response_block_text(key, value)
        }
      }
    end

    def yes_response_block_text(key, value)
      "*#{key}:* "\
      "#{value}"
    end

    def build_body
      {}.tap do |body|
        body[:response_type] = 'ephemeral' if blocks.blank?
      end.merge(super)
    end

    def error_block_text
      "There was an error adding the new `#{self.class::KLASS}` record for your request, sorry!"
    end
  end
end

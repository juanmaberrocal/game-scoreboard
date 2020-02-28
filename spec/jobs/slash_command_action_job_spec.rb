require 'rails_helper'

RSpec.describe SlashCommandActionJob, type: :job do
  include ActiveJob::TestHelper

  let(:response_url) { 'https://stub.webmock.com/slack_url' }
  let(:user_id) { 'foo' }

  before(:each) { ActiveJob::Base.queue_adapter = :test }

  context 'Successful request' do
    %w[add view].each do |action|
      %w[game games player players match].each do |model|
        context "#{action}:#{model}" do
          let(:action_text) { "#{action}:#{model}" }
          let(:parser) { SlashCommandActionParser.new(action_text) }
          let(:selector) { SlashCommandActionServicePicker.new(action, model) }
          let(:service) { "slash_command_actions/#{model}_#{action}_service".classify.constantize.new('') }
          let(:job) { SlashCommandActionJob.perform_later(response_url, user_id, action_text) }

          it 'parses action|model|params' do
            expect(SlashCommandActionParser).to receive(:new).with(action_text)
                                                             .and_return(parser)
            expect(parser).to receive(:parse).and_return([action, model, nil])

            perform_enqueued_jobs { job }
          end

          it "selects #{"#{model}_#{action}_service".classify} service" do
            expect(SlashCommandActionServicePicker).to receive(:new).with(action, model)
                                                                    .and_return(selector)

            if (action == 'add' && (model == 'games' || model == 'players')) ||
               (action == 'view' && model == 'games')
              expect(selector).to receive(:select).and_raise(InvalidSlashCommand)
            else
              expect(selector).to receive(:select).and_return(service)
            end

            perform_enqueued_jobs { job }
          end
        end
      end
    end
  end

  context 'Error triggers SlackPostRequest' do
    let(:job) { SlashCommandActionJob.perform_later(response_url, user_id, action) }
    let(:action) { 'foo:bar' }
    let(:default_error_text) { SlashCommandJob::DEFAULT_ERROR_MESSAGE }
    let(:error_message) do
      {
        response_type: 'ephemeral',
        blocks: [
          {
            type: 'section',
            text: {
              type: 'mrkdwn',
              text: default_error_text
            }
          }
        ]
      }
    end

    it 'when `InvalidSlashCommand` is raised' do
      error_message[:blocks].first[:text][:text] = InvalidSlashCommand.new(action).message

      allow_any_instance_of(SlashCommandActionJob).to receive(:perform_slash_command).and_raise(InvalidSlashCommand.new(action))
      expect(SlackPostRequest).to receive(:new).with(response_url, user_id)
                                               .and_return(SlackPostRequest.new(response_url, user_id))
      expect_any_instance_of(SlackPostRequest).to receive(:post).with(error_message)

      perform_enqueued_jobs { job }
    end

    it 'when exception is raised' do
      allow_any_instance_of(SlashCommandActionJob).to receive(:perform_slash_command).and_raise('foo')
      expect(SlackPostRequest).to receive(:new).with(response_url, user_id)
                                               .and_return(SlackPostRequest.new(response_url, user_id))
      expect_any_instance_of(SlackPostRequest).to receive(:post).with(error_message)

      perform_enqueued_jobs { job }
    end
  end
end

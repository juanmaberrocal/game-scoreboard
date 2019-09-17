require 'rails_helper'

RSpec.describe "V2/SlashCommand", type: :request do
  describe "POST /game_scoreboard" do
    let(:command) { '/game-scoreboard' }
    let(:headers) do
      {
        'X-Slack-Signature' => 'foo',
        'X-Slack-Request-Timestamp' => Time.now.to_i
      }
    end

    let(:response_type) { 'ephemeral' }
    let(:default_success_text) do
      'Sounds good, processing request. Please wait a minute.'
    end
    let(:default_error_text) do
      'Sorry, that didn\'t work. Please try again.'
    end

    context 'authentication' do
      let(:params) { {} }

      context 'failed with invalid authentication' do
        it 'returns `text` as `InvalidSlackRequest#message`' do
          allow_any_instance_of(SlackRequestAuthenticator).to receive(:authenticate!).and_raise(InvalidSlackRequest)
          
          post v2_slash_command_game_scoreboard_path, params: params, headers: headers
          expect(json_body['text']).to eq(InvalidSlackRequest.new.message)
        end

        include_examples("Slack API Response")
      end

      context 'failed with invalid request' do
        it 'returns `text` as default error message' do
          allow_any_instance_of(SlackRequestAuthenticator).to receive(:authenticate!).and_raise('foo')

          post v2_slash_command_game_scoreboard_path, params: params, headers: headers
          expect(json_body['text']).to eq(default_error_text)
        end

        include_examples("Slack API Response")
      end
    end

    context 'validation' do
      let(:params) do
        {
          command: command,
          text: 'view:players'
        }
      end
      
      before(:each) do
        allow_any_instance_of(SlackRequestAuthenticator).to receive(:authenticate!).and_return(true)
      end

      context 'failed with invalid command' do
        it 'returns `text` as `InvalidSlashCommand#message`' do
          params.delete(:command)

          post v2_slash_command_game_scoreboard_path, params: params, headers: headers
          expect(json_body['text']).to eq(InvalidSlashCommand.new("#{params[:command]} #{params[:text]}").message)
        end

        include_examples("Slack API Response")
      end

      context 'failed with invalid action' do
        it 'returns `text` as `InvalidSlashCommand#message`' do
          params.delete(:text)

          post v2_slash_command_game_scoreboard_path, params: params, headers: headers
          expect(json_body['text']).to eq(InvalidSlashCommand.new("#{params[:command]} #{params[:text]}").message)
        end

        include_examples("Slack API Response")
      end
    end

    context 'actions' do
      before(:each) do
        ActiveJob::Base.queue_adapter = :test
        allow_any_instance_of(SlackRequestAuthenticator).to receive(:authenticate!).and_return(true)
      end

      %w[add view].each do |action|
        %w[game games player players match].each do |model|
          context "#{action}:#{model}" do
            let(:params) do
              {
                command: command,
                text: "#{action}:#{model}"
              }
            end

            it 'returns `text` as `default success message`' do
              post v2_slash_command_game_scoreboard_path, params: params, headers: headers
              expect(json_body['text']).to eq(default_success_text)
            end
        
            include_examples("Slack API Response")
          end
        end
      end
    end
  end
end

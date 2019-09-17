require 'rails_helper'

RSpec.describe Api::V2::SlashCommandController, type: :controller do
  let(:command) { '/game-scoreboard' }

  before(:each) do
    ActiveJob::Base.queue_adapter = :test
  end

  describe "POST #game_scoreboard" do
    context 'with invalid authorization' do
      let(:params) { {} }

      it 'does not enqueue `SlashCommandActionJob` job' do
        expect {
          post :game_scoreboard, params: params
        }.to_not have_enqueued_job(SlashCommandActionJob)
      end
    end

    context 'with invalid request' do
      let(:params) do
        {
          command: command,
          text: 'view:players'
        }
      end

      before(:each) do
        allow_any_instance_of(SlackRequestAuthenticator).to receive(:authenticate!).and_return(true)
      end

      it 'does not enqueue `SlashCommandActionJob` job with invalid command' do
        params.delete(:command)

        expect {
          post :game_scoreboard, params: params
        }.to_not have_enqueued_job(SlashCommandActionJob)
      end

      it 'does not enqueue `SlashCommandActionJob` job with invalid action' do
        params.delete(:text)

        expect {
          post :game_scoreboard, params: params
        }.to_not have_enqueued_job(SlashCommandActionJob)
      end
    end

    context 'with valid request' do
      before(:each) do
        allow_any_instance_of(SlackRequestAuthenticator).to receive(:authenticate!).and_return(true)
      end

      %w[add view].each do |action|
        %w[game games player players match].each do |model|
          context "#{action}:#{model}" do
            let(:response_url) { 'https://stub.webmock.com/slack_url' }
            let(:params) do
              {
                command: command,
                text: "#{action}:#{model}",
                response_url: response_url,
                user_id: 'foo'
              }
            end

            it 'enqueues `SlashCommandActionJob` job' do
              expect {
                post :game_scoreboard, params: params
              }.to have_enqueued_job(SlashCommandActionJob).with(params[:response_url],
                                                                 params[:user_id],
                                                                 params[:text])
            end
          end
        end
      end
    end
  end
end

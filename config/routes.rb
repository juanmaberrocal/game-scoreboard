# frozen_string_literal: true

Rails.application.routes.draw do
  # concerns
  concern :with_matches do
    resources :matches, only: %i[index show]
  end

  concern :with_statistics do
    get 'statistics', on: :member
  end

  concern :with_standings do
    get 'standings', on: :member
  end

  # /api/
  # constraints subdomain: 'api' do
    scope module: 'api' do
      # /api/v1/
      namespace :v1 do
        # /api/v1/games
        resources :games, concerns: %i[
          with_matches
          with_statistics
          with_standings
        ]

        # /api/v1/matches
        resources :matches, only: %i[index show create] do
          # /api/v1/matches/:id/match_players
          resources :match_players, only: %i[index show], shallow: true do
            member do
              post 'confirm'
              post 'reject'
            end
          end
        end

        # /api/v1/players
        resources :players, concerns: %i[
          with_matches
          with_statistics
          with_standings
        ] do
          resources :games, only: %i[index]
        end

        # /api/v1/slack_bot
        namespace :slack_bot do
          post 'game_score'
          post 'game_scoreboard'

          post 'match_score'

          post 'player_score'
          post 'player_scoreboard'
        end
      end

      # /api/v2/
      namespace :v2 do
        # /api/v2/slash_command
        namespace :slash_command do
          post 'game_scoreboard'
        end

        namespace :slack_bot do
        end
      end
    end
  # end

  scope module: 'system' do
    get 'ping'
  end

  devise_for :players, skip: :all
  devise_scope :player do
    get    'renew',  to: 'sessions#renew',   as: :renew_player_session
    post   'login',  to: 'sessions#create',  as: :player_session
    delete 'logout', to: 'sessions#destroy', as: :destroy_player_session

    post 'signup',   to: 'registrations#create', as: :player_registration
    post 'update_password', to: 'registrations#update_password',
                            as: :update_password_player_registration
  end
end

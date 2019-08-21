Rails.application.routes.draw do
  # /api/
  # constraints subdomain: 'api' do
    scope module: 'api' do
      # /api/v1/
      namespace :v1 do
        # /api/v1/games
        resources :games
        
        # /api/v1/matches
        resources :matches

        # /api/v1/match_players
        resources :match_players

        # /api/v1/players
        resources :players

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
    # end
  end

  scope module: 'system' do
    get 'ping'
  end

  devise_for :players,
             path: '',
             path_names: {
               sign_in: 'login',
               sign_out: 'logout'
             },
             controllers: {
               sessions: 'sessions'
             }

  devise_scope :player do
    get 'renew', to: 'sessions#renew', as: :player_session_renew
  end
end

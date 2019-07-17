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
          # get  'authorize'
          post 'game_score'
          post 'game_scoreboard'
          
          post 'match_score'

          post 'player_score'
          post 'player_scoreboard'
        end
      end
    # end
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

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
      end
    # end
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

namespace :matches do
  desc 'Add new match result for a specific game'
  task :add, [:game, :match_players] => [:environment] do |_t, args|
    game = Game.find_by_name(args[:game]) || Game.find_by(id: args[:game])
    abort("Game `#{args[:game]}` not found!") unless game.present?

    ActiveRecord::Base.transaction do
      match = Match.create(game: game)

      players_scores = args[:match_players].split(/-/)
      players_scores.each do |player_score|
        player_name, score = player_score.split(':')

        player = Player.find_by_name(player_name)
        abort("Player #{player_name} not found!") unless player.present?

        MatchPlayer.create(match: match, player: player, winner: (score == '1' ? true : false))
      end
    end
  end
end

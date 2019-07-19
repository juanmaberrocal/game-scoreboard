namespace :matches do
  desc 'Add new match result for a specific game'
  task :add, [:game, :match_players] => [:environment] do |_t, args|
    match_results = [].tap do |results|
                      args[:match_players].split(/-/).each do |match_player|
                        player_name, score = match_player.split(':')
                        results << { player_name => score }
                      end
                    end

    match = Match.create_with_results(args[:game], match_results)
    abort("Match could not be created!") unless match.present?
  end
end

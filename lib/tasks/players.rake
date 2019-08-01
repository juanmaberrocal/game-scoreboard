namespace :players do
  desc 'Update player emails so they unique'
  task :unique_emails => [:environment] do |_t, args|
    Player.select(:email).group(:email).each do |player_email|
      email = player_email.email

      Player.where(email: email).each_with_index do |player, i|
        unique_email = "#{i.zero? ? '' : i}#{email}"
        player.update(email: unique_email)
      end
    end
  end
end

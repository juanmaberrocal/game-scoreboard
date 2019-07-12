# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

games = [
  {
    name: 'Asshole',
    description: 'Asshole is a popular, but more complex and competitive turn based card drinking game. '\
                 'Your position each round yields to an initial pre-game advantage (or disadvantage), '\
                 'and positions are won by getting rid of your cards the fastest.',
    min_players: 3,
    max_players: 8,
    min_play_time: 5,
    max_play_time: 15
  },
  {
    name: 'Catan',
    description: 'In Catan (formerly The Settlers of Catan), '\
                 'players try to be the dominant force on the island of Catan by building settlements, cities, and roads. '\
                 'On each turn dice are rolled to determine what resources the island produces. '\
                 'Players collect these resources (cards)—wood, grain, brick, sheep, or stone—to build up their civilizations '\
                 'to get to 10 victory points and win the game.',
    min_players: 3,
    max_players: 4,
    min_play_time: 60,
    max_play_time: 120
  },
  {
    name: 'Codenames',
    description: 'Two rival spymasters know the agent in each location. '\
                 'They deliver coded messages telling their field operatives where to go for clandestine meetings. '\
                 'Operatives must be clever. '\
                 'A decoding mistake could lead to an unpleasant encounter with an enemy agent – or worse, with the assassin! '\
                 'Both teams race to contact all their agents, but only one team can win.',
    min_players: 2,
    max_players: 8,
    min_play_time: 15,
    max_play_time: 15
  },
  {
    name: 'Monopoly Deal',
    description: 'The fast-paced, addictive card game where your luck can change in the play of a card! '\
                 'Collect 3 complete property sets, but beware Debt Collectors, Forced Deals and the dreaded Deal Breakers, '\
                 'which could change your fortunes at any time!',
    min_players: 2,
    max_players: 5,
    min_play_time: 15,
    max_play_time: 15
  },
  {
    name: 'Mille Bornes',
    description: 'One Thousand Milestones. '\
                 'On French roads there were small marker stones giving the distance in kilometres to the next town. '\
                 'In this famous old French card game, players compete to drive 1000 km, dealing with hazards along the way. '\
                 'Draw a card to your hand, play or discard. '\
                 'You must lay a green traffic light to start, play cards showing mileage, dump hazards (flat tire, speed limit) '\
                 'on the other players, remedy hazards (spare tire, end of limit) from yourself, '\
                 'play safety cards (puncture proof), and try to be the first to clock up the distance.',
    min_players: 2,
    max_players: 6,
    min_play_time: 45,
    max_play_time: 45
  },
  {
    name: 'Sequence',
    description: 'Sequence is a board and card game. '\
                 'The board shows all the cards (except for the Jacks) of two (2) standard 52-card decks, laid in a 10 x 10 pattern. '\
                 'The four corners are free spaces and count for all players equally.',
    min_players: 2,
    max_players: 12,
    min_play_time: 10,
    max_play_time: 30
  },
  {
    name: 'Sushi Go Party!',
    description: 'Sushi Go Party!, an expanded version of the best-selling card game Sushi Go!, '\
                 'is a party platter of mega maki, super sashimi, and endless edamame. '\
                 'You still earn points by picking winning sushi combos, '\
                 'but now you can customize each game by choosing à la carte from a menu of more than twenty delectable dishes. '\
                 'What\'s more, up to eight players can join in on the sushi-feast. Let the good times roll!',
    min_players: 2,
    max_players: 8,
    min_play_time: 20,
    max_play_time: 20
  }
]

games.each do |g|
  game = Game.find_or_initialize_by(name: g[:name])
  game.update(g)
end

players = [
  { first_name: 'Juan', last_name: 'Berrocal', nickname: 'juanma', birth_date: '' },
  { first_name: 'Carolina', last_name: 'Navarrete', nickname: 'caro', birth_date: '' },
  { first_name: 'Marina', last_name: 'Chevis', nickname: 'ma', birth_date: '' },
  { first_name: 'Dulce', last_name: 'Casado', nickname: 'dul', birth_date: '' }
]

players.each do |pl|
  player = Player.find_or_initialize_by(first_name: pl[:first_name], last_name: pl[:last_name])
  player.update(pl)
end

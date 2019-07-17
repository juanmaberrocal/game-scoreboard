class StandingsGeneratorService
  attr_reader :klass, :record,
              :data_array

  def initialize(klass, record)
    @klass  = klass
    @record = record
  end

  # [
  #   { name: <String>, num_won: <Integer> },
  #   { name: <String>, num_won: <Integer> }
  #   ...
  # ]
  def generate(data_array)
    @data_array = data_array

    ordered_array = data_array.sort_by { |a| -a[:num_won] }
    ordered_array.each_with_index { |a, i| a[:position] = (i + 1) }
    ordered_array
  end

  private

  EMPTY_DATA_ENTRY = { name: nil, num_won: 0 }.freeze

  def game_list
    @games ||= Game.all.select(:id, :name)
  end

  def player_list
    @players ||= Player.all.select(:id, :first_name, :last_name, :nickname)
  end
end

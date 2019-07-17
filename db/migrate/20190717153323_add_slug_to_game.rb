class AddSlugToGame < ActiveRecord::Migration[6.0]
  def up
    return if column_exists?(:games, :slug)
    add_column(:games, :slug, :string, after: :name)

    Game.all.each do |g|
      g.update(slug: g.name.parameterize)
    end
  end

  def down
    return unless column_exists?(:games, :slug)
    remove_column(:games, :slug)
  end
end

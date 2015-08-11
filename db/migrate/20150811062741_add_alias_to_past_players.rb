class AddAliasToPastPlayers < ActiveRecord::Migration
  def change
  	add_column(:past_players, :alias, :string)
  end
end

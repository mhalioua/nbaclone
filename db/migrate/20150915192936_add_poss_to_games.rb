class AddPossToGames < ActiveRecord::Migration
  def change
  	add_column :games, :full_game_poss, :float
  	add_column :games, :first_half_poss, :float
  	add_column :games, :second_half_poss, :float
  	add_column :games, :first_quarter_poss, :float
  end
end

class ChangeSpread < ActiveRecord::Migration
  def change
  	add_column :games, :full_game_spread, :float
  	add_column :games, :first_half_spread, :float
  	add_column :games, :second_half_spread, :float
  	add_column :games, :first_quarter_spread, :float
  end
end

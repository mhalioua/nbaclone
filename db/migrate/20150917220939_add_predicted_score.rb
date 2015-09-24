class AddPredictedScore < ActiveRecord::Migration
  def change
  	add_column :games, :away_full_game_score, :float
  	add_column :games, :home_full_game_score, :float
  	add_column :games, :away_first_half_score, :float
  	add_column :games, :home_first_half_score, :float
  	add_column :games, :away_second_half_score, :float
  	add_column :games, :home_second_half_score, :float
  	add_column :games, :away_first_quarter_score, :float
  	add_column :games, :home_first_quarter_score, :float
  	remove_column :games, :full_game_ps
  	remove_column :games, :full_game_spread
  	remove_column :games, :first_half_ps
  	remove_column :games, :first_half_spread
  	remove_column :games, :second_half_ps
  	remove_column :games, :second_half_spread
  	remove_column :games, :first_quarter_ps
  	remove_column :games, :first_quarter_spread
  end
end

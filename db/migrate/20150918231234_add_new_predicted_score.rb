class AddNewPredictedScore < ActiveRecord::Migration
  def change
  	add_column :games, :away_full_game_score_2, :float
  	add_column :games, :home_full_game_score_2, :float
  	add_column :games, :away_first_half_score_2, :float
  	add_column :games, :home_first_half_score_2, :float
  	add_column :games, :away_second_half_score_2, :float
  	add_column :games, :home_second_half_score_2, :float
  	add_column :games, :away_first_quarter_score_2, :float
  	add_column :games, :home_first_quarter_score_2, :float
  end
end

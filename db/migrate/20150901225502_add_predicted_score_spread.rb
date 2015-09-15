class AddPredictedScoreSpread < ActiveRecord::Migration
  def change
  	add_column :games, :away_full_game_ps, :float
  	add_column :games, :home_full_game_ps, :float
  	add_column :games, :away_first_half_ps, :float
  	add_column :games, :home_first_half_ps, :float
  	add_column :games, :away_first_quarter_ps, :float
  	add_column :games, :home_first_quarter_ps, :float
  end
end

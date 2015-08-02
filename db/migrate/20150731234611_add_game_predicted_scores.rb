class AddGamePredictedScores < ActiveRecord::Migration
  def change
  	add_column :games, :ideal_algorithm, :float
  	add_column :games, :ideal_possessions, :float
  	add_column :games, :ideal_pace, :float
  	add_column :games, :first_quarter_ps_2, :float
  	add_column :starters, :ideal_ortg, :float

  end
end

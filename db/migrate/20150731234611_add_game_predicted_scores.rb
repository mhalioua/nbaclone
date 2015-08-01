class AddGamePredictedScores < ActiveRecord::Migration
  def change
  	add_column :games, :ideal_possessions, :float
  	add_column :games, :ideal_score, :float
  end
end

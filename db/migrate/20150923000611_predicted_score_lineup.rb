class PredictedScoreLineup < ActiveRecord::Migration
  def change
  	add_column :lineups, :predicted_score, :float
  end
end

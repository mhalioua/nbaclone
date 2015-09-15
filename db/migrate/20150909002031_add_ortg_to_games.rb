class AddOrtgToGames < ActiveRecord::Migration
  def change
  	add_column :games, :away_ortg, :float
  	add_column :games, :home_ortg, :float
  end
end

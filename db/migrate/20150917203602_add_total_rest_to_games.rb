class AddTotalRestToGames < ActiveRecord::Migration
  def change
  	add_column :games, :total_rest, :integer
  end
end

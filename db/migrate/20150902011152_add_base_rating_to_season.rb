class AddBaseRatingToSeason < ActiveRecord::Migration
  def change
  	add_column :seasons, :base_ortg, :float
  	add_column :seasons, :base_drtg, :float
  	add_column :seasons, :base_poss, :float
  end
end

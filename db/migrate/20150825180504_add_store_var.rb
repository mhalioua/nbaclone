class AddStoreVar < ActiveRecord::Migration
  def change
  	add_column :starters, :ortg, :float
  	add_column :lineups, :poss, :float
  end
end

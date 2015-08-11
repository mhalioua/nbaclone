class AddStarterVar < ActiveRecord::Migration
  def change
  	add_column :starters, :ideal_poss, :float
  end
end

class AddOrtg < ActiveRecord::Migration
  def change
  	add_column :lineups, :ortg, :float
  end
end

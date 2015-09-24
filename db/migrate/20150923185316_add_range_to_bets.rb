class AddRangeToBets < ActiveRecord::Migration
  def change
  	add_column :bets, :range, :float
  end
end

class AddSecondHalf < ActiveRecord::Migration
  def change

  	add_column :games, :second_half_ps, :float
  	add_column :games, :away_second_half_ps, :float
  	add_column :games, :home_second_half_ps, :float
  	add_column :games, :second_half_cl, :float
  	add_column :games, :second_half_open, :float
  	add_column :games, :second_half_spread, :float

  end
end

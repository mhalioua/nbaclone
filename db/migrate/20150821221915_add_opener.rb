class AddOpener < ActiveRecord::Migration
  def change
  	add_column :games, :full_game_open, :float
  	add_column :games, :first_half_open, :float
  	add_column :games, :first_quarter_open, :float
  end
end

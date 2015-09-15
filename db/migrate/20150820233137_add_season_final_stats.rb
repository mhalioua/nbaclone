class AddSeasonFinalStats < ActiveRecord::Migration
  def change
  	add_column :seasons, :full_game_full_year_win, :float
  	add_column :seasons, :full_game_full_year_size, :integer
  	add_column :seasons, :full_game_first_half_year_win, :float
  	add_column :seasons, :full_game_first_half_year_size, :integer
  	add_column :seasons, :full_game_second_half_year_win, :float
  	add_column :seasons, :full_game_second_half_year_size, :integer
  	add_column :seasons, :first_half_full_year_win, :float
  	add_column :seasons, :first_half_full_year_size, :integer
  	add_column :seasons, :first_half_first_half_year_win, :float
  	add_column :seasons, :first_half_first_half_year_size, :integer
  	add_column :seasons, :first_half_second_half_year_win, :float
  	add_column :seasons, :first_half_second_half_year_size, :integer
  	add_column :seasons, :first_quarter_full_year_win, :float
  	add_column :seasons, :first_quarter_full_year_size, :integer
  	add_column :seasons, :first_quarter_first_half_year_win, :float
  	add_column :seasons, :first_quarter_first_half_year_size, :integer
  	add_column :seasons, :first_quarter_second_half_year_win, :float
  	add_column :seasons, :first_quarter_second_half_year_size, :integer
  end
end

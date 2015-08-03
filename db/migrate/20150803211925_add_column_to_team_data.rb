class AddColumnToTeamData < ActiveRecord::Migration
  def change
  	add_column :game_dates, :standard_deviation, :float
  	add_column :game_dates, :mean, :float
  end
end

class AddColumnToTeamData < ActiveRecord::Migration
  def change
  	add_column :game_dates, :standard_deviation, :float
  	add_column :game_dates, :mean, :float
  	add_column :game_dates, :weekday, :string
  	# add_column :team_data, :rest, :integer
  end
end

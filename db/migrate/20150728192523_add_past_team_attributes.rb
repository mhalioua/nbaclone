class AddPastTeamAttributes < ActiveRecord::Migration
  def change
  	add_column :past_teams, :name, :string
  	add_column :past_teams, :abbr, :string
  	add_column :past_teams, :city, :string
  end
end

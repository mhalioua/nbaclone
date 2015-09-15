class AddRankingToPastTeam < ActiveRecord::Migration
  def change
  	add_column :past_teams, :off_ranking, :integer
  	add_column :past_teams, :def_ranking, :integer
  	add_column :past_teams, :pace_ranking, :integer
  	add_column :past_teams, :win_ranking, :integer
  	add_column :past_teams, :win, :integer
  	add_column :past_teams, :loss, :integer
  	add_column :past_teams, :win_percentage, :float

  end
end

class AddRankingDistanceToGame < ActiveRecord::Migration
  def change
  	add_column(:games, :away_ranking, :integer)
  	add_column(:games, :home_ranking, :integer)
  	add_column(:games, :away_rest, :integer)
  	add_column(:games, :home_rest, :integer)
  	add_column(:games, :away_record, :integer)
  	add_column(:games, :home_record, :integer)
  	add_column(:team_data, :win, :integer)
  	add_column(:team_data, :loss, :integer)
  	add_column(:team_data, :win_percentage, :float)
  end
end

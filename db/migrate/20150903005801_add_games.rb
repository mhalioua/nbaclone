class AddGames < ActiveRecord::Migration
  def change
  	add_column :seasons, :base_games, :integer
  	add_column :seasons, :away_games, :integer
  	add_column :seasons, :home_games, :integer
  	add_column :seasons, :zero_games, :integer
  	add_column :seasons, :one_games, :integer
  	add_column :seasons, :two_games, :integer
  	add_column :seasons, :three_games, :integer
  	add_column :past_teams, :base_games, :integer
  	add_column :past_teams, :away_games, :integer
  	add_column :past_teams, :home_games, :integer
  	add_column :past_teams, :zero_games, :integer
  	add_column :past_teams, :one_games, :integer
  	add_column :past_teams, :two_games, :integer
  	add_column :past_teams, :three_games, :integer
  end
end

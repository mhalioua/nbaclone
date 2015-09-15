class RemoveErroneous < ActiveRecord::Migration
  def change

  	remove_column :past_teams, :base_games

  	remove_column :past_teams, :away_ortg
  	remove_column :past_teams, :away_drtg
  	remove_column :past_teams, :away_poss
  	remove_column :past_teams, :away_games
  	remove_column :past_teams, :home_ortg
  	remove_column :past_teams, :home_drtg
  	remove_column :past_teams, :home_poss
  	remove_column :past_teams, :home_games
  	remove_column :past_teams, :zero_ortg
  	remove_column :past_teams, :zero_drtg
  	remove_column :past_teams, :zero_poss
  	remove_column :past_teams, :zero_games
  	remove_column :past_teams, :one_ortg
  	remove_column :past_teams, :one_drtg
  	remove_column :past_teams, :one_poss
  	remove_column :past_teams, :one_games
  	remove_column :past_teams, :two_ortg
  	remove_column :past_teams, :two_drtg
  	remove_column :past_teams, :two_poss
  	remove_column :past_teams, :two_games
  	remove_column :past_teams, :three_ortg
  	remove_column :past_teams, :three_drtg
  	remove_column :past_teams, :three_poss
  	remove_column :past_teams, :three_games

  	remove_column :past_teams, :zero_zero_ortg
  	remove_column :past_teams, :zero_zero_drtg
  	remove_column :past_teams, :zero_zero_poss
  	remove_column :past_teams, :zero_zero_games
  	remove_column :past_teams, :zero_one_ortg
  	remove_column :past_teams, :zero_one_drtg
  	remove_column :past_teams, :zero_one_poss
  	remove_column :past_teams, :zero_one_games
  	remove_column :past_teams, :zero_two_ortg
  	remove_column :past_teams, :zero_two_drtg
  	remove_column :past_teams, :zero_two_poss
  	remove_column :past_teams, :zero_two_games
  	remove_column :past_teams, :zero_three_ortg
  	remove_column :past_teams, :zero_three_drtg
  	remove_column :past_teams, :zero_three_poss
  	remove_column :past_teams, :zero_three_games

  	remove_column :past_teams, :one_zero_ortg
  	remove_column :past_teams, :one_zero_drtg
  	remove_column :past_teams, :one_zero_poss
  	remove_column :past_teams, :one_zero_games
  	remove_column :past_teams, :one_one_ortg
  	remove_column :past_teams, :one_one_drtg
  	remove_column :past_teams, :one_one_poss
  	remove_column :past_teams, :one_one_games
  	remove_column :past_teams, :one_two_ortg
  	remove_column :past_teams, :one_two_drtg
  	remove_column :past_teams, :one_two_poss
  	remove_column :past_teams, :one_two_games
  	remove_column :past_teams, :one_three_ortg
  	remove_column :past_teams, :one_three_drtg
  	remove_column :past_teams, :one_three_poss
  	remove_column :past_teams, :one_three_games

  	remove_column :past_teams, :two_zero_ortg
  	remove_column :past_teams, :two_zero_drtg
  	remove_column :past_teams, :two_zero_poss
  	remove_column :past_teams, :two_zero_games
  	remove_column :past_teams, :two_one_ortg
  	remove_column :past_teams, :two_one_drtg
  	remove_column :past_teams, :two_one_poss
  	remove_column :past_teams, :two_one_games
  	remove_column :past_teams, :two_two_ortg
  	remove_column :past_teams, :two_two_drtg
  	remove_column :past_teams, :two_two_poss
  	remove_column :past_teams, :two_two_games
  	remove_column :past_teams, :two_three_ortg
  	remove_column :past_teams, :two_three_drtg
  	remove_column :past_teams, :two_three_poss
  	remove_column :past_teams, :two_three_games

  	remove_column :past_teams, :three_zero_ortg
  	remove_column :past_teams, :three_zero_drtg
  	remove_column :past_teams, :three_zero_poss
  	remove_column :past_teams, :three_zero_games
  	remove_column :past_teams, :three_one_ortg
  	remove_column :past_teams, :three_one_drtg
  	remove_column :past_teams, :three_one_poss
  	remove_column :past_teams, :three_one_games
  	remove_column :past_teams, :three_two_ortg
  	remove_column :past_teams, :three_two_drtg
  	remove_column :past_teams, :three_two_poss
  	remove_column :past_teams, :three_two_games
  	remove_column :past_teams, :three_three_ortg
  	remove_column :past_teams, :three_three_drtg
  	remove_column :past_teams, :three_three_poss
  	remove_column :past_teams, :three_three_games

  end
end

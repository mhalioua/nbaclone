class RemoveMOre < ActiveRecord::Migration
  def change
  	remove_column :past_teams, :base_ortg
  	remove_column :past_teams, :base_drtg
  	remove_column :past_teams, :base_poss

  	remove_column :seasons, :full_game_full_year_win
  	remove_column :seasons, :full_game_full_year_size
  	remove_column :seasons, :full_game_first_half_year_win
  	remove_column :seasons, :full_game_first_half_year_size
  	remove_column :seasons, :full_game_second_half_year_win
  	remove_column :seasons, :full_game_second_half_year_size

  	remove_column :seasons, :first_half_full_year_win
  	remove_column :seasons, :first_half_full_year_size
  	remove_column :seasons, :first_half_first_half_year_win
  	remove_column :seasons, :first_half_first_half_year_size
  	remove_column :seasons, :first_half_second_half_year_win
  	remove_column :seasons, :first_half_second_half_year_size

  	remove_column :seasons, :first_quarter_full_year_win
  	remove_column :seasons, :first_quarter_full_year_size
  	remove_column :seasons, :first_quarter_first_half_year_win
  	remove_column :seasons, :first_quarter_first_half_year_size
  	remove_column :seasons, :first_quarter_second_half_year_win
  	remove_column :seasons, :first_quarter_second_half_year_size

  	remove_column :seasons, :base_ortg
  	remove_column :seasons, :base_drtg
  	remove_column :seasons, :base_poss
  	remove_column :seasons, :base_games

  	remove_column :seasons, :away_ortg
  	remove_column :seasons, :away_drtg
  	remove_column :seasons, :away_poss
  	remove_column :seasons, :away_games

  	remove_column :seasons, :home_ortg
  	remove_column :seasons, :home_drtg
  	remove_column :seasons, :home_poss
  	remove_column :seasons, :home_games

	remove_column :seasons, :zero_ortg
  	remove_column :seasons, :zero_drtg
  	remove_column :seasons, :zero_poss
  	remove_column :seasons, :zero_games

  	remove_column :seasons, :one_ortg
  	remove_column :seasons, :one_drtg
  	remove_column :seasons, :one_poss
  	remove_column :seasons, :one_games

  	remove_column :seasons, :two_ortg
  	remove_column :seasons, :two_drtg
  	remove_column :seasons, :two_poss
  	remove_column :seasons, :two_games

	remove_column :seasons, :three_ortg
  	remove_column :seasons, :three_drtg
  	remove_column :seasons, :three_poss
  	remove_column :seasons, :three_games

  	remove_column :seasons, :zero_zero_ortg
  	remove_column :seasons, :zero_zero_drtg
  	remove_column :seasons, :zero_zero_poss
  	remove_column :seasons, :zero_zero_games

  	remove_column :seasons, :zero_one_ortg
  	remove_column :seasons, :zero_one_drtg
  	remove_column :seasons, :zero_one_poss
  	remove_column :seasons, :zero_one_games

  	remove_column :seasons, :zero_two_ortg
  	remove_column :seasons, :zero_two_drtg
  	remove_column :seasons, :zero_two_poss
  	remove_column :seasons, :zero_two_games

  	remove_column :seasons, :zero_three_ortg
  	remove_column :seasons, :zero_three_drtg
  	remove_column :seasons, :zero_three_poss
  	remove_column :seasons, :zero_three_games

  	remove_column :seasons, :one_zero_ortg
  	remove_column :seasons, :one_zero_drtg
  	remove_column :seasons, :one_zero_poss
  	remove_column :seasons, :one_zero_games

  	remove_column :seasons, :one_one_ortg
  	remove_column :seasons, :one_one_drtg
  	remove_column :seasons, :one_one_poss
  	remove_column :seasons, :one_one_games

  	remove_column :seasons, :one_two_ortg
  	remove_column :seasons, :one_two_drtg
  	remove_column :seasons, :one_two_poss
  	remove_column :seasons, :one_two_games

  	remove_column :seasons, :one_three_ortg
  	remove_column :seasons, :one_three_drtg
  	remove_column :seasons, :one_three_poss
  	remove_column :seasons, :one_three_games

  	remove_column :seasons, :two_zero_ortg
  	remove_column :seasons, :two_zero_drtg
  	remove_column :seasons, :two_zero_poss
  	remove_column :seasons, :two_zero_games

  	remove_column :seasons, :two_one_ortg
  	remove_column :seasons, :two_one_drtg
  	remove_column :seasons, :two_one_poss
  	remove_column :seasons, :two_one_games

  	remove_column :seasons, :two_two_ortg
  	remove_column :seasons, :two_two_drtg
  	remove_column :seasons, :two_two_poss
  	remove_column :seasons, :two_two_games

  	remove_column :seasons, :two_three_ortg
  	remove_column :seasons, :two_three_drtg
  	remove_column :seasons, :two_three_poss
  	remove_column :seasons, :two_three_games

  	remove_column :seasons, :three_zero_ortg
  	remove_column :seasons, :three_zero_drtg
  	remove_column :seasons, :three_zero_poss
  	remove_column :seasons, :three_zero_games

  	remove_column :seasons, :three_one_ortg
  	remove_column :seasons, :three_one_drtg
  	remove_column :seasons, :three_one_poss
  	remove_column :seasons, :three_one_games

  	remove_column :seasons, :three_two_ortg
  	remove_column :seasons, :three_two_drtg
  	remove_column :seasons, :three_two_poss
  	remove_column :seasons, :three_two_games

  	remove_column :seasons, :three_three_ortg
  	remove_column :seasons, :three_three_drtg
  	remove_column :seasons, :three_three_poss
  	remove_column :seasons, :three_three_games

  end
end

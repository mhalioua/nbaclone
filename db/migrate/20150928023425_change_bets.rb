class ChangeBets < ActiveRecord::Migration
  def change
  	rename_column :bets, :win_percent, :total_win_percent
  	rename_column :bets, :total_bet, :total_win_bet
  	rename_column :bets, :win_games, :total_lose_bet
  	rename_column :bets, :win_by_points, :total_bet
  	rename_column :bets, :lose_games, :spread_win_bet
  	rename_column :bets, :lose_by_points, :spread_lose_bet
  	rename_column :bets, :spread_total_bet, :spread_bet
  end
end

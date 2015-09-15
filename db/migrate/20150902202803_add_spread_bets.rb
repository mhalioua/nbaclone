class AddSpreadBets < ActiveRecord::Migration
  def change
  	add_column :bets, :spread_win_percent, :float
  	add_column :bets, :spread_total_bet, :float
  end
end

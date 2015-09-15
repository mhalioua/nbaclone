class WinLosePoints < ActiveRecord::Migration
  def change
  	add_column :bets, :win_games, :integer
  	add_column :bets, :win_by_points, :float
  	add_column :bets, :lose_games, :integer
  	add_column :bets, :lose_by_points, :float
  end
end

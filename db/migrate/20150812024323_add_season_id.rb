class AddSeasonId < ActiveRecord::Migration
  def change
  	add_reference :lineups, :season, index: true
  	add_reference :starters, :season, index: true
  	add_reference :actions, :season, index: true
  	add_reference :past_players, :season, index: true
  	add_reference :games, :season, index: true
  end
end

class AddRest < ActiveRecord::Migration
  def change
  	add_column :past_teams, :zero_ortg, :float
  	add_column :past_teams, :zero_drtg, :float
  	add_column :past_teams, :zero_poss, :float
  	add_column :past_teams, :one_ortg, :float
  	add_column :past_teams, :one_drtg, :float
  	add_column :past_teams, :one_poss, :float
  	add_column :past_teams, :two_ortg, :float
  	add_column :past_teams, :two_drtg, :float
  	add_column :past_teams, :two_poss, :float
  	add_column :past_teams, :three_ortg, :float
  	add_column :past_teams, :three_drtg, :float
  	add_column :past_teams, :three_poss, :float

  	add_column :seasons, :zero_ortg, :float
  	add_column :seasons, :zero_drtg, :float
  	add_column :seasons, :zero_poss, :float
  	add_column :seasons, :one_ortg, :float
  	add_column :seasons, :one_drtg, :float
  	add_column :seasons, :one_poss, :float
  	add_column :seasons, :two_ortg, :float
  	add_column :seasons, :two_drtg, :float
  	add_column :seasons, :two_poss, :float
  	add_column :seasons, :three_ortg, :float
  	add_column :seasons, :three_drtg, :float
  	add_column :seasons, :three_poss, :float
  end
end

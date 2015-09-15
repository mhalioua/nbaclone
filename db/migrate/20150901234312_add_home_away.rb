class AddHomeAway < ActiveRecord::Migration

  def change
  	add_column :past_teams, :away_ortg, :float
  	add_column :past_teams, :away_drtg, :float
  	add_column :past_teams, :away_poss, :float
  	add_column :past_teams, :home_ortg, :float
  	add_column :past_teams, :home_drtg, :float
  	add_column :past_teams, :home_poss, :float
  	add_column :seasons, :away_ortg, :float
  	add_column :seasons, :away_drtg, :float
  	add_column :seasons, :away_poss, :float
  	add_column :seasons, :home_ortg, :float
  	add_column :seasons, :home_drtg, :float
  	add_column :seasons, :home_poss, :float
  end

end

class AddStuffToTeamData < ActiveRecord::Migration
  def change
  	rename_column :team_data, :base_ortg, :full_game_base_ortg
  	rename_column :team_data, :base_drtg, :full_game_base_drtg
  	rename_column :team_data, :base_poss, :full_game_base_poss
  	rename_column :team_data, :season_ortg, :full_game_season_ortg
  	rename_column :team_data, :season_drtg, :full_game_season_drtg
  	rename_column :team_data, :season_poss, :full_game_season_poss
  	add_column :team_data, :first_half_base_ortg, :float
  	add_column :team_data, :first_half_base_drtg, :float
  	add_column :team_data, :first_half_base_poss, :float
  	add_column :team_data, :first_half_season_ortg, :float
  	add_column :team_data, :first_half_season_drtg, :float
  	add_column :team_data, :first_half_season_poss, :float
  	add_column :team_data, :first_quarter_base_ortg, :float
  	add_column :team_data, :first_quarter_base_drtg, :float
  	add_column :team_data, :first_quarter_base_poss, :float
  	add_column :team_data, :first_quarter_season_ortg, :float
  	add_column :team_data, :first_quarter_season_drtg, :float
  	add_column :team_data, :first_quarter_season_poss, :float
  end
end

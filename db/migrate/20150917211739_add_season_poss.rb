class AddSeasonPoss < ActiveRecord::Migration
  def change
  	add_column :team_data, :season_poss, :float
  end
end

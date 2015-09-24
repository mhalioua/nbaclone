class AddFullSeasonDrtg < ActiveRecord::Migration
  def change
  	add_column :team_data, :season_drtg, :float
  end
end

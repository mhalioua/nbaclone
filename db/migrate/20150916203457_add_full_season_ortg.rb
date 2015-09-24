class AddFullSeasonOrtg < ActiveRecord::Migration
  def change
  	add_column :team_data, :season_ortg, :float
  end
end

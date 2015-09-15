class AddTeamDataBasePOss < ActiveRecord::Migration
  def change
  	add_column :team_data, :base_poss, :float
  end
end

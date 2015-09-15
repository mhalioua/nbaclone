class AddBasePoss < ActiveRecord::Migration
  def change
  	add_column :past_teams, :base_poss, :float
  end
end

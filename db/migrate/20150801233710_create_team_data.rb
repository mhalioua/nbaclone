class CreateTeamData < ActiveRecord::Migration
  def change
    create_table :team_data do |t|
    	t.references :game_date, index: true
    	t.references :past_team, index: true
    	t.float "avg_points"
    	t.integer "ranking"
      t.timestamps
    end

  end
end

class CreateTeamData < ActiveRecord::Migration
  def change
    create_table :team_data do |t|
    	t.references :game_date, index: true
    	t.references :past_team, index: true
    	t.float "base_ortg"
    	t.float "base_drtg"
    	t.integer "ranking"
    	t.integer "rest"
    	t.integer "win"
    	t.integer "loss"
    	t.float "win_percentage"
      t.timestamps
    end

  end
end

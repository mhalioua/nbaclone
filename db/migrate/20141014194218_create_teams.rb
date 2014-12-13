class CreateTeams < ActiveRecord::Migration
  def up
    create_table :teams do |t|
    	t.string "name"
      t.string "city"
      t.references :yesterday_team, :class_name => "Team"
      t.references :today_team, :class_name => "Team"
      t.references :tomorrow_team, :class_name => "Team"
		  t.boolean "yesterday"
		  t.boolean "today"
		  t.boolean "tomorrow"
      t.string "opp_yesterday" #TODO change string to link to team
		  t.string "opp_today"
		  t.string "opp_tomorrow"
      t.integer "G"
      t.integer "PTS"
      t.float "FGP"
      t.float "ThPP"
      t.integer "ThPA"
      t.float "opp_ThPP"
      t.integer "opp_ThPA"
      t.float "pace"
      t.timestamps
    end
    add_index("teams", "name")
  end

  def down
  	drop_table :teams
  end
end

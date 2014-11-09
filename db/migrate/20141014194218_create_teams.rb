class CreateTeams < ActiveRecord::Migration
  def up
    create_table :teams do |t|
    	t.string "name"
      t.string "city"
		  t.boolean "yesterday"
		  t.boolean "today"
		  t.boolean "tomorrow"
      t.string "opp_yesterday" #TODO change string to link to team
		  t.string "opp_today"
		  t.string "opp_tomorrow"
      t.timestamps
    end
    add_index("teams", "name")
  end

  def down
  	drop_table :teams
  end
end

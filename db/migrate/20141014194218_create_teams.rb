class CreateTeams < ActiveRecord::Migration
  def up
    create_table :teams do |t|
    	t.string "name"
		  t.boolean "yesterday"
		  t.boolean "today"
		  t.boolean "tomorrow"
      t.string "opp_yesterday"
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

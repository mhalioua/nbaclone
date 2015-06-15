class CreatePastTeams < ActiveRecord::Migration
  def up
    create_table :past_teams do |t|
    	
      t.references :team
      t.string "year"
      t.timestamps

    end
  end

  def down

  	drop_table :past_teams

  end
end

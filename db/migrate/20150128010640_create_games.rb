class CreateGames < ActiveRecord::Migration
  def up
    create_table :games do |t|

    	t.references :away_team
    	t.references :home_team
    	t.string "date"

      t.timestamps
    end
  end

  def down

  	drop_table :games

  end
end

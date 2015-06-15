class CreatePastPlayers < ActiveRecord::Migration
  def up
    create_table :past_players do |t|

      t.references :player
      t.references :past_team
      t.string "year"
      t.timestamps
    end
  end

  def down
  	drop_table :past_players
  end
end

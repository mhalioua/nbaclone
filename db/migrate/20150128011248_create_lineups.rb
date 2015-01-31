class CreateLineups < ActiveRecord::Migration
  def up
    create_table :lineups do |t|

    	t.references :game
    	t.integer "quarter"
    	t.integer "player1"
    	t.integer "player2"
    	t.integer "player3"
    	t.integer "player4"
    	t.integer "player5"
    	t.integer "player6"
    	t.integer "player7"
    	t.integer "player8"
    	t.integer "player9"
    	t.integer "player10"

      t.timestamps
    end
  end

  def down

  	drop_table :lineups

  end
end

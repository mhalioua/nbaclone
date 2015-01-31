class CreateActions < ActiveRecord::Migration
  def up
    create_table :actions do |t|

    	t.references :game
    	t.integer "quarter"
    	t.float "time"
    	t.string "action"
    	t.string "player1"
    	t.string "player2"

      t.timestamps

    end

  end

  def down

  	drop_table :actions

  end

end

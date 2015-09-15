class CreateActions < ActiveRecord::Migration
  def change
    create_table :actions do |t|

    	t.references :game
      t.references :season
    	t.integer "quarter"
    	t.float "time"
    	t.string "action"
    	t.string "player1"
    	t.string "player2"

      t.timestamps

    end

  end

end

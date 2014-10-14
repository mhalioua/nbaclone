class CreatePlayers < ActiveRecord::Migration
  def up
    create_table :players do |t|

    	t.references :team
    	
    	t.string "name"

      t.timestamps
    end
  end

  def down
  	drop_table :players
  end
end

class CreatePlayerMatchups < ActiveRecord::Migration
  def up
    create_table :player_matchups do |t|

    	t.references :player_one, :class_name => "Player"
    	t.references :player_two, :class_name => "Player"

      
      t.timestamps
    end
  end

  def down
  	drop_table :player_matchups
  end
end

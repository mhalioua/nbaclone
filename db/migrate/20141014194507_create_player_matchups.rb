class CreatePlayerMatchups < ActiveRecord::Migration
  def change
    create_table :player_matchups do |t|

    	t.references :player_one, :class_name => "Player"
    	t.references :player_two, :class_name => "Player"
      
      t.timestamps
    end
  end
end

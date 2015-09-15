class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
    	t.references :team
      t.boolean "starter", :default => false
    	t.string "name"
      t.string "alias"
      t.string "height"
      t.string "position"

      t.timestamps
    end
    add_index("players", "name")
    add_index("players", "alias")
  end
end

class CreatePlayers < ActiveRecord::Migration
  def up
    create_table :players do |t|
    	t.references :team
      t.boolean "starter", :default => false
    	t.string "name"
      t.string "alias"
      t.string "position"
      t.boolean "forward", :default => false
      t.boolean "guard", :default => false
      t.integer "GS"
      t.integer "MP"
      t.integer "FG"
      t.integer "FGA"
      t.float "FGP"
      t.integer "ThP"
      t.integer "ThPA"
      t.float "ThPP"
      t.integer "FT"
      t.integer "FTA"
      t.float "FTP"
      t.integer "ORB"
      t.integer "DRB"
      t.integer "AST"
      t.integer "STL"
      t.integer "BLK"
      t.integer "TO"
      t.integer "PF"
      t.integer "PTS"
      t.timestamps
    end
    add_index("players", "name")
  end

  def down
  	drop_table :players
  end
end

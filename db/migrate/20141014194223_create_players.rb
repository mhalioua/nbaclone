class CreatePlayers < ActiveRecord::Migration
  def up
    create_table :players do |t|
    	t.references :team
      t.boolean "starter", :default => false
    	t.string "name"
      t.string "alias"
      t.string "height"
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
      t.integer "ORtg"
      t.integer "DRtg"
      t.float "eFG"
      t.float "TS"
      t.float "MP_1"
      t.float "MP_2"
      t.float "MP_3"
      t.float "MP_4"
      t.float "MP_5"
      t.integer "MP_2014", :default => 0
      t.integer "ORtg_2014", :default => 0
      t.integer "DRtg_2014", :default => 0
      t.timestamps
    end
    add_index("players", "name")
  end

  def down
  	drop_table :players
  end
end

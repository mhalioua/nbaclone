class CreateStarters < ActiveRecord::Migration
  def up
    create_table :starters do |t|

    	t.references :team, :class_name => "Lineup"
      t.references :opponent, :class_name => "Lineup"
    	t.references :past_player
      t.string "name", :default => ""
      t.string "alias", :default => ""
      t.string "position", :default => ""
      t.boolean "starter", :default => false
      t.boolean "home", :default => false
      t.integer "quarter", :default => 0
      t.float "mp", :default => 0
      t.float "fgm", :default => 0
      t.float "fga", :default => 0
      t.float "thpm", :default => 0
      t.float "thpa", :default => 0
      t.float "ftm", :default => 0
      t.float "fta", :default => 0
      t.float "orb", :default => 0
      t.float "drb", :default => 0
      t.float "ast", :default => 0
      t.float "stl", :default => 0
      t.float "blk", :default => 0
      t.float "tov", :default => 0
      t.float "pf", :default => 0
      t.float "pts", :default => 0

      t.timestamps
    end
    add_index("starters", "name")
    add_index("starters", "alias")
  end

  def down
  	drop_table :starters
  end
end

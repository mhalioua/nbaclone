class CreateLineups < ActiveRecord::Migration
  def up
    create_table :lineups do |t|

    	t.references :game
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
  end

  def down

  	drop_table :lineups

  end
end

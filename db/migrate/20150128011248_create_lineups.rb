class CreateLineups < ActiveRecord::Migration
  def up
    create_table :lineups do |t|

    	t.references :game
      t.boolean "home", :default => false
    	t.integer "quarter", :default => 0
      t.integer "ast", :default => 0
      t.integer "tov", :default => 0
      t.integer "pts", :default => 0
      t.integer "ftm", :default => 0
      t.integer "fta", :default => 0
      t.integer "thpm", :default => 0
      t.integer "thpa", :default => 0
      t.integer "fgm", :default => 0
      t.integer "fga", :default => 0
      t.integer "orb", :default => 0
      t.integer "drb", :default => 0
      t.integer "stl", :default => 0
      t.integer "blk", :default => 0
      t.integer "pf", :default => 0
      t.float "mp", :default => 0

      t.timestamps
    end
  end

  def down

  	drop_table :lineups

  end
end

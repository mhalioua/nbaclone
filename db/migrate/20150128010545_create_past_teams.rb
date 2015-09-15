class CreatePastTeams < ActiveRecord::Migration
  def change
    create_table :past_teams do |t| 	
    t.references :season
    t.references :team
    t.string "name"
    t.string "abbr"
    t.string "city"
    t.float "base_ortg", :default => 0
    t.float "base_drtg", :default => 0
    t.integer "games", :default => 0
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
end

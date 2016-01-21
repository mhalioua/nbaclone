class CreateStarters < ActiveRecord::Migration
  def change
    create_table :starters do |t|

      t.references :season
      t.references :game
      t.references :team, :class_name => "Lineup"
      t.references :opponent, :class_name => "Lineup"
      t.references :past_player
      t.string "alias"
      t.boolean "starter"
      t.boolean "home"
      t.integer "quarter"
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
      t.float "poss_percent", :default => 0

      t.timestamps
    end

      add_index("starters", "alias")
  
  end
end
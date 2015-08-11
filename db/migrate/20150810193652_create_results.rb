class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.references :past_team
      t.references :season
      t.references :opponent
      t.text "description"
      t.integer "games"
      t.integer "quarter"
      t.boolean "home"
      t.boolean "weekend"
      t.boolean "travel"
      t.integer "rest"
      t.integer "offensive_efficiency"
      t.integer "win_percentage"
      t.integer "pace"
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

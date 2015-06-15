class CreateGames < ActiveRecord::Migration
  def up
    create_table :games do |t|

    	t.references :away_team
    	t.references :home_team
      # t.references :away_game
      # t.references :home_game
      t.float "ps"
      t.float "first_half_ps"
      t.string "year"
      t.string "month"
      t.string "day"
      t.float "opener"
      t.float "westgate"
      t.float "mirage"
      t.float "station"
      t.float "pinnacle"
      t.float "sia"
      t.float "sbg"
      t.float "betus"
      t.float "betphoenix"
      t.float "easystreet"
      t.float "bodog"
      t.float "jazz"
      t.float "sportsbet"
      t.float "bookmaker"
      t.float "dsi"

      t.timestamps
    end
  end

  def down

  	drop_table :games

  end
end

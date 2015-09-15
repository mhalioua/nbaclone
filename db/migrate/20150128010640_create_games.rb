class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|

      t.references :season
      t.references :game_date
    	t.references :away_team
    	t.references :home_team
      t.float "full_game_ps"
      t.float "first_half_ps"
      t.float "first_quarter_ps"
      t.float "full_game_cl"
      t.float "first_half_cl"
      t.float "first_quarter_cl"
      t.integer  "away_ranking"
      t.integer  "home_ranking"
      t.integer  "away_rest"
      t.integer  "home_rest"
      t.integer  "away_record"
      t.integer  "home_record"
      t.integer  "away_travel"
      t.integer  "home_travel"
      t.boolean  "weekend"

      t.timestamps
    end
  end
end

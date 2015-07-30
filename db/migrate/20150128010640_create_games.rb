class CreateGames < ActiveRecord::Migration
  def up
    create_table :games do |t|

    	t.references :away_team
    	t.references :home_team
      t.string "year"
      t.string "month"
      t.string "day"
      t.float "full_game_ps"
      t.float "first_half_ps"
      t.float "first_quarter_ps"
      t.float "possessions_ps"
      t.float "ortg_ps"
      t.float "full_game_cl"
      t.float "first_half_cl"
      t.float "first_quarter_cl"

      t.timestamps
    end
  end

  def down

  	drop_table :games

  end
end

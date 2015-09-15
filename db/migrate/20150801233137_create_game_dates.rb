class CreateGameDates < ActiveRecord::Migration
  def change
    create_table :game_dates do |t|
      t.references :season
    	t.string "year"
    	t.string "month"
    	t.string "day"
    	t.string "weekday"
      t.timestamps
    end

  end
end

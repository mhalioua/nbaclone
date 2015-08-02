class CreateGameDates < ActiveRecord::Migration
  def change
    create_table :game_dates do |t|
    	t.string "year"
    	t.string "month"
    	t.string "day"
    	t.float "avg_points"
      t.timestamps
    end

    add_reference :games, :game_date, index: true
  end
end

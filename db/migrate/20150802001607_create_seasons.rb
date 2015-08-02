class CreateSeasons < ActiveRecord::Migration
  def change
    create_table :seasons do |t|
    	t.string "year"
      t.timestamps
    end

    add_reference :game_dates, :season, index: true
    add_reference :past_teams, :season, index: true

  end
end

class CreateTeams < ActiveRecord::Migration
  def up
    create_table :teams do |t|
    	t.string "name"
      t.string "city"
      t.references :yesterday_team, :class_name => "Team"
      t.references :today_team, :class_name => "Team"
      t.references :tomorrow_team, :class_name => "Team"
		  t.boolean "yesterday"
		  t.boolean "today"
		  t.boolean "tomorrow"
      t.integer "G"
      t.integer "PTS"
      t.float "FGP"
      t.float "ThPP"
      t.integer "ThPA"
      t.float "opp_ThPP"
      t.integer "opp_ThPA"
      t.float "pace"
      t.integer "rank"
      t.integer "home_G", :default => 0
      t.float "home_FG", :default => 0
      t.float "home_FGA", :default => 0
      t.float "home_FTA", :default => 0
      t.float "home_TOV", :default => 0
      t.float "home_PTS", :default => 0
      t.float "home_opp_FG", :default => 0
      t.float "home_opp_FGA", :default => 0
      t.float "home_opp_FTA", :default => 0
      t.float "home_opp_TOV", :default => 0
      t.float "home_opp_PTS", :default => 0
      t.integer "away_G", :default => 0
      t.float "away_FG", :default => 0
      t.float "away_FGA", :default => 0
      t.float "away_FTA", :default => 0
      t.float "away_TOV", :default => 0
      t.float "away_PTS", :default => 0
      t.float "away_opp_FG", :default => 0
      t.float "away_opp_FGA", :default => 0
      t.float "away_opp_FTA", :default => 0
      t.float "away_opp_TOV", :default => 0
      t.float "away_opp_PTS", :default => 0
      t.integer "sun_G", :default => 0
      t.float "sun_FG", :default => 0
      t.float "sun_FGA", :default => 0
      t.float "sun_FTA", :default => 0
      t.float "sun_TOV", :default => 0
      t.float "sun_PTS", :default => 0
      t.float "sun_opp_FG", :default => 0
      t.float "sun_opp_FGA", :default => 0
      t.float "sun_opp_FTA", :default => 0
      t.float "sun_opp_TOV", :default => 0
      t.float "sun_opp_PTS", :default => 0
      t.integer "mon_G", :default => 0
      t.float "mon_FG", :default => 0
      t.float "mon_FGA", :default => 0
      t.float "mon_FTA", :default => 0
      t.float "mon_TOV", :default => 0
      t.float "mon_PTS", :default => 0
      t.float "mon_opp_FG", :default => 0
      t.float "mon_opp_FGA", :default => 0
      t.float "mon_opp_FTA", :default => 0
      t.float "mon_opp_TOV", :default => 0
      t.float "mon_opp_PTS", :default => 0
      t.integer "tue_G", :default => 0
      t.float "tue_FG", :default => 0
      t.float "tue_FGA", :default => 0
      t.float "tue_FTA", :default => 0
      t.float "tue_TOV", :default => 0
      t.float "tue_PTS", :default => 0
      t.float "tue_opp_FG", :default => 0
      t.float "tue_opp_FGA", :default => 0
      t.float "tue_opp_FTA", :default => 0
      t.float "tue_opp_TOV", :default => 0
      t.float "tue_opp_PTS", :default => 0
      t.integer "wed_G", :default => 0
      t.float "wed_FG", :default => 0
      t.float "wed_FGA", :default => 0
      t.float "wed_FTA", :default => 0
      t.float "wed_TOV", :default => 0
      t.float "wed_PTS", :default => 0
      t.float "wed_opp_FG", :default => 0
      t.float "wed_opp_FGA", :default => 0
      t.float "wed_opp_FTA", :default => 0
      t.float "wed_opp_TOV", :default => 0
      t.float "wed_opp_PTS", :default => 0
      t.integer "thu_G", :default => 0
      t.float "thu_FG", :default => 0
      t.float "thu_FGA", :default => 0
      t.float "thu_FTA", :default => 0
      t.float "thu_TOV", :default => 0
      t.float "thu_PTS", :default => 0
      t.float "thu_opp_FG", :default => 0
      t.float "thu_opp_FGA", :default => 0
      t.float "thu_opp_FTA", :default => 0
      t.float "thu_opp_TOV", :default => 0
      t.float "thu_opp_PTS", :default => 0
      t.integer "fri_G", :default => 0
      t.float "fri_FG", :default => 0
      t.float "fri_FGA", :default => 0
      t.float "fri_FTA", :default => 0
      t.float "fri_TOV", :default => 0
      t.float "fri_PTS", :default => 0
      t.float "fri_opp_FG", :default => 0
      t.float "fri_opp_FGA", :default => 0
      t.float "fri_opp_FTA", :default => 0
      t.float "fri_opp_TOV", :default => 0
      t.float "fri_opp_PTS", :default => 0
      t.integer "sat_G", :default => 0
      t.float "sat_FG", :default => 0
      t.float "sat_FGA", :default => 0
      t.float "sat_FTA", :default => 0
      t.float "sat_TOV", :default => 0
      t.float "sat_PTS", :default => 0
      t.float "sat_opp_FG", :default => 0
      t.float "sat_opp_FGA", :default => 0
      t.float "sat_opp_FTA", :default => 0
      t.float "sat_opp_TOV", :default => 0
      t.float "sat_opp_PTS", :default => 0
      t.integer "zero_G", :default => 0
      t.float "zero_FG", :default => 0
      t.float "zero_FGA", :default => 0
      t.float "zero_FTA", :default => 0
      t.float "zero_TOV", :default => 0
      t.float "zero_PTS", :default => 0
      t.float "zero_opp_FG", :default => 0
      t.float "zero_opp_FGA", :default => 0
      t.float "zero_opp_FTA", :default => 0
      t.float "zero_opp_TOV", :default => 0
      t.float "zero_opp_PTS", :default => 0
      t.integer "one_G", :default => 0
      t.float "one_FG", :default => 0
      t.float "one_FGA", :default => 0
      t.float "one_FTA", :default => 0
      t.float "one_TOV", :default => 0
      t.float "one_PTS", :default => 0
      t.float "one_opp_FG", :default => 0
      t.float "one_opp_FGA", :default => 0
      t.float "one_opp_FTA", :default => 0
      t.float "one_opp_TOV", :default => 0
      t.float "one_opp_PTS", :default => 0
      t.integer "two_G", :default => 0
      t.float "two_FG", :default => 0
      t.float "two_FGA", :default => 0
      t.float "two_FTA", :default => 0
      t.float "two_TOV", :default => 0
      t.float "two_PTS", :default => 0
      t.float "two_opp_FG", :default => 0
      t.float "two_opp_FGA", :default => 0
      t.float "two_opp_FTA", :default => 0
      t.float "two_opp_TOV", :default => 0
      t.float "two_opp_PTS", :default => 0
      t.integer "three_G", :default => 0
      t.float "three_FG", :default => 0
      t.float "three_FGA", :default => 0
      t.float "three_FTA", :default => 0
      t.float "three_TOV", :default => 0
      t.float "three_PTS", :default => 0
      t.float "three_opp_FG", :default => 0
      t.float "three_opp_FGA", :default => 0
      t.float "three_opp_FTA", :default => 0
      t.float "three_opp_TOV", :default => 0
      t.float "three_opp_PTS", :default => 0
      t.timestamps
    end
    add_index("teams", "name")
  end

  def down
  	drop_table :teams
  end
end
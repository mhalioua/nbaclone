class CreatePlayerMatchupGames < ActiveRecord::Migration
  def up
    create_table :player_matchup_games do |t|

      t.references :player_matchup
      t.string "name"
      t.string "date"
      t.integer "GS"
      t.float "MP"
      t.integer "FG"
      t.integer "FGA"
      t.float "FGP"
      t.integer "ThP"
      t.integer "ThPA"
      t.float "ThPP"
      t.integer "FT"
      t.integer "FTA"
      t.float "FTP"
      t.integer "ORB"
      t.integer "DRB"
      t.integer "AST"
      t.integer "STL"
      t.integer "BLK"
      t.integer "TO"
      t.integer "PF"
      t.integer "PTS"

      t.timestamps
    end
  end

  def down
  	drop_table :player_matchup_games
  end
end

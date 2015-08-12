# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150812024323) do

  create_table "actions", force: true do |t|
    t.integer  "game_id"
    t.integer  "quarter"
    t.float    "time",       limit: 24
    t.string   "action"
    t.string   "player1"
    t.string   "player2"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "season_id"
  end

  add_index "actions", ["season_id"], name: "index_actions_on_season_id", using: :btree

  create_table "game_dates", force: true do |t|
    t.string   "year"
    t.string   "month"
    t.string   "day"
    t.float    "avg_points",         limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "season_id"
    t.float    "standard_deviation", limit: 24
    t.float    "mean",               limit: 24
    t.string   "weekday"
  end

  add_index "game_dates", ["season_id"], name: "index_game_dates_on_season_id", using: :btree

  create_table "games", force: true do |t|
    t.integer  "away_team_id"
    t.integer  "home_team_id"
    t.string   "year"
    t.string   "month"
    t.string   "day"
    t.float    "full_game_ps",       limit: 24
    t.float    "first_half_ps",      limit: 24
    t.float    "first_quarter_ps",   limit: 24
    t.float    "possessions_ps",     limit: 24
    t.float    "ortg_ps",            limit: 24
    t.float    "full_game_cl",       limit: 24
    t.float    "first_half_cl",      limit: 24
    t.float    "first_quarter_cl",   limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "ideal_algorithm",    limit: 24
    t.float    "ideal_possessions",  limit: 24
    t.float    "ideal_pace",         limit: 24
    t.float    "first_quarter_ps_2", limit: 24
    t.integer  "game_date_id"
    t.integer  "away_ranking"
    t.integer  "home_ranking"
    t.integer  "away_rest"
    t.integer  "home_rest"
    t.integer  "away_record"
    t.integer  "home_record"
    t.boolean  "weekend"
    t.integer  "away_travel"
    t.integer  "home_travel"
    t.integer  "season_id"
  end

  add_index "games", ["game_date_id"], name: "index_games_on_game_date_id", using: :btree
  add_index "games", ["season_id"], name: "index_games_on_season_id", using: :btree

  create_table "lineups", force: true do |t|
    t.integer  "game_id"
    t.boolean  "home",                   default: false
    t.integer  "quarter",                default: 0
    t.float    "mp",          limit: 24, default: 0.0
    t.float    "fgm",         limit: 24, default: 0.0
    t.float    "fga",         limit: 24, default: 0.0
    t.float    "thpm",        limit: 24, default: 0.0
    t.float    "thpa",        limit: 24, default: 0.0
    t.float    "ftm",         limit: 24, default: 0.0
    t.float    "fta",         limit: 24, default: 0.0
    t.float    "orb",         limit: 24, default: 0.0
    t.float    "drb",         limit: 24, default: 0.0
    t.float    "ast",         limit: 24, default: 0.0
    t.float    "stl",         limit: 24, default: 0.0
    t.float    "blk",         limit: 24, default: 0.0
    t.float    "tov",         limit: 24, default: 0.0
    t.float    "pf",          limit: 24, default: 0.0
    t.float    "pts",         limit: 24, default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "opponent_id"
    t.integer  "season_id"
  end

  add_index "lineups", ["opponent_id"], name: "index_lineups_on_opponent_id", using: :btree
  add_index "lineups", ["season_id"], name: "index_lineups_on_season_id", using: :btree

  create_table "past_players", force: true do |t|
    t.integer  "player_id"
    t.integer  "past_team_id"
    t.string   "year"
    t.float    "mp",           limit: 24, default: 0.0
    t.float    "fgm",          limit: 24, default: 0.0
    t.float    "fga",          limit: 24, default: 0.0
    t.float    "thpm",         limit: 24, default: 0.0
    t.float    "thpa",         limit: 24, default: 0.0
    t.float    "ftm",          limit: 24, default: 0.0
    t.float    "fta",          limit: 24, default: 0.0
    t.float    "orb",          limit: 24, default: 0.0
    t.float    "drb",          limit: 24, default: 0.0
    t.float    "ast",          limit: 24, default: 0.0
    t.float    "stl",          limit: 24, default: 0.0
    t.float    "blk",          limit: 24, default: 0.0
    t.float    "tov",          limit: 24, default: 0.0
    t.float    "pf",           limit: 24, default: 0.0
    t.float    "pts",          limit: 24, default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "alias"
    t.integer  "season_id"
  end

  add_index "past_players", ["season_id"], name: "index_past_players_on_season_id", using: :btree

  create_table "past_teams", force: true do |t|
    t.integer  "team_id"
    t.string   "year"
    t.float    "mp",            limit: 24, default: 0.0
    t.float    "fgm",           limit: 24, default: 0.0
    t.float    "fga",           limit: 24, default: 0.0
    t.float    "thpm",          limit: 24, default: 0.0
    t.float    "thpa",          limit: 24, default: 0.0
    t.float    "ftm",           limit: 24, default: 0.0
    t.float    "fta",           limit: 24, default: 0.0
    t.float    "orb",           limit: 24, default: 0.0
    t.float    "drb",           limit: 24, default: 0.0
    t.float    "ast",           limit: 24, default: 0.0
    t.float    "stl",           limit: 24, default: 0.0
    t.float    "blk",           limit: 24, default: 0.0
    t.float    "tov",           limit: 24, default: 0.0
    t.float    "pf",            limit: 24, default: 0.0
    t.float    "pts",           limit: 24, default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "abbr"
    t.string   "city"
    t.integer  "season_id"
    t.float    "total_pts",     limit: 24
    t.float    "total_opp_pts", limit: 24
    t.integer  "total_size"
    t.float    "sun_pts",       limit: 24
    t.float    "sun_opp_pts",   limit: 24
    t.integer  "sun_size"
    t.float    "mon_pts",       limit: 24
    t.float    "mon_opp_pts",   limit: 24
    t.integer  "mon_size"
    t.float    "tue_pts",       limit: 24
    t.float    "tue_opp_pts",   limit: 24
    t.integer  "tue_size"
    t.float    "wed_pts",       limit: 24
    t.float    "wed_opp_pts",   limit: 24
    t.integer  "wed_size"
    t.float    "thu_pts",       limit: 24
    t.float    "thu_opp_pts",   limit: 24
    t.integer  "thu_size"
    t.float    "fri_pts",       limit: 24
    t.float    "fri_opp_pts",   limit: 24
    t.integer  "fri_size"
    t.float    "sat_pts",       limit: 24
    t.float    "sat_opp_pts",   limit: 24
    t.integer  "sat_size"
    t.float    "zero_pts",      limit: 24
    t.float    "zero_opp_pts",  limit: 24
    t.integer  "zero_size"
    t.float    "one_pts",       limit: 24
    t.float    "one_opp_pts",   limit: 24
    t.integer  "one_size"
    t.float    "two_pts",       limit: 24
    t.float    "two_opp_pts",   limit: 24
    t.integer  "two_size"
    t.float    "three_pts",     limit: 24
    t.float    "three_opp_pts", limit: 24
    t.integer  "three_size"
  end

  add_index "past_teams", ["season_id"], name: "index_past_teams_on_season_id", using: :btree

  create_table "player_matchup_games", force: true do |t|
    t.integer  "player_matchup_id"
    t.string   "name"
    t.string   "date"
    t.integer  "GS"
    t.float    "MP",                limit: 24
    t.integer  "FG"
    t.integer  "FGA"
    t.float    "FGP",               limit: 24
    t.integer  "ThP"
    t.integer  "ThPA"
    t.float    "ThPP",              limit: 24
    t.integer  "FT"
    t.integer  "FTA"
    t.float    "FTP",               limit: 24
    t.integer  "ORB"
    t.integer  "DRB"
    t.integer  "AST"
    t.integer  "STL"
    t.integer  "BLK"
    t.integer  "TO"
    t.integer  "PF"
    t.integer  "PTS"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "player_matchups", force: true do |t|
    t.integer  "player_one_id"
    t.integer  "player_two_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "players", force: true do |t|
    t.integer  "team_id"
    t.boolean  "starter",                      default: false
    t.string   "name"
    t.string   "alias"
    t.string   "height"
    t.string   "position"
    t.boolean  "forward",                      default: false
    t.boolean  "guard",                        default: false
    t.integer  "GS"
    t.integer  "G"
    t.integer  "MP"
    t.integer  "FG"
    t.integer  "FGA"
    t.float    "FGP",               limit: 24
    t.integer  "ThP"
    t.integer  "ThPA"
    t.float    "ThPP",              limit: 24
    t.integer  "FT"
    t.integer  "FTA"
    t.float    "FTP",               limit: 24
    t.integer  "ORB"
    t.integer  "DRB"
    t.integer  "STL"
    t.integer  "TO"
    t.integer  "PF"
    t.integer  "PTS"
    t.integer  "AST"
    t.integer  "ORtg"
    t.integer  "DRtg"
    t.float    "eFG",               limit: 24
    t.float    "TS",                limit: 24
    t.float    "MP_1",              limit: 24
    t.float    "MP_2",              limit: 24
    t.float    "MP_3",              limit: 24
    t.float    "MP_4",              limit: 24
    t.float    "MP_5",              limit: 24
    t.float    "MP_AVG",            limit: 24
    t.string   "team_1"
    t.string   "team_2"
    t.string   "team_3"
    t.string   "team_4"
    t.string   "team_5"
    t.string   "date_1"
    t.string   "date_2"
    t.string   "date_3"
    t.string   "date_4"
    t.string   "date_5"
    t.integer  "MP_2014",                      default: 0
    t.integer  "ORtg_2014",                    default: 0
    t.integer  "DRtg_2014",                    default: 0
    t.float    "on_court_pace",     limit: 24, default: 0.0
    t.float    "opp_on_court_pace", limit: 24, default: 0.0
    t.float    "on_court_ORtg",     limit: 24, default: 0.0
    t.float    "opp_on_court_ORtg", limit: 24, default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "players", ["alias"], name: "index_players_on_alias", using: :btree
  add_index "players", ["name"], name: "index_players_on_name", using: :btree

  create_table "results", force: true do |t|
    t.integer  "past_team_id"
    t.integer  "season_id"
    t.integer  "opponent_id"
    t.text     "description"
    t.integer  "games"
    t.integer  "quarter"
    t.boolean  "home"
    t.boolean  "weekend"
    t.boolean  "travel"
    t.integer  "rest"
    t.integer  "offensive_efficiency"
    t.integer  "win_percentage"
    t.integer  "pace"
    t.float    "mp",                   limit: 24, default: 0.0
    t.float    "fgm",                  limit: 24, default: 0.0
    t.float    "fga",                  limit: 24, default: 0.0
    t.float    "thpm",                 limit: 24, default: 0.0
    t.float    "thpa",                 limit: 24, default: 0.0
    t.float    "ftm",                  limit: 24, default: 0.0
    t.float    "fta",                  limit: 24, default: 0.0
    t.float    "orb",                  limit: 24, default: 0.0
    t.float    "drb",                  limit: 24, default: 0.0
    t.float    "ast",                  limit: 24, default: 0.0
    t.float    "stl",                  limit: 24, default: 0.0
    t.float    "blk",                  limit: 24, default: 0.0
    t.float    "tov",                  limit: 24, default: 0.0
    t.float    "pf",                   limit: 24, default: 0.0
    t.float    "pts",                  limit: 24, default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "seasons", force: true do |t|
    t.string   "year"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "starters", force: true do |t|
    t.integer  "team_id"
    t.integer  "opponent_id"
    t.integer  "past_player_id"
    t.string   "name",                      default: ""
    t.string   "alias",                     default: ""
    t.string   "position",                  default: ""
    t.boolean  "starter",                   default: false
    t.boolean  "home",                      default: false
    t.integer  "quarter",                   default: 0
    t.float    "mp",             limit: 24, default: 0.0
    t.float    "fgm",            limit: 24, default: 0.0
    t.float    "fga",            limit: 24, default: 0.0
    t.float    "thpm",           limit: 24, default: 0.0
    t.float    "thpa",           limit: 24, default: 0.0
    t.float    "ftm",            limit: 24, default: 0.0
    t.float    "fta",            limit: 24, default: 0.0
    t.float    "orb",            limit: 24, default: 0.0
    t.float    "drb",            limit: 24, default: 0.0
    t.float    "ast",            limit: 24, default: 0.0
    t.float    "stl",            limit: 24, default: 0.0
    t.float    "blk",            limit: 24, default: 0.0
    t.float    "tov",            limit: 24, default: 0.0
    t.float    "pf",             limit: 24, default: 0.0
    t.float    "pts",            limit: 24, default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "ideal_ortg",     limit: 24
    t.float    "ideal_poss",     limit: 24
    t.float    "poss_percent",   limit: 24
    t.integer  "season_id"
  end

  add_index "starters", ["alias"], name: "index_starters_on_alias", using: :btree
  add_index "starters", ["name"], name: "index_starters_on_name", using: :btree
  add_index "starters", ["season_id"], name: "index_starters_on_season_id", using: :btree

  create_table "team_data", force: true do |t|
    t.integer  "game_date_id"
    t.integer  "past_team_id"
    t.float    "avg_points",     limit: 24
    t.integer  "ranking"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "rest"
    t.integer  "win"
    t.integer  "loss"
    t.float    "win_percentage", limit: 24
  end

  add_index "team_data", ["game_date_id"], name: "index_team_data_on_game_date_id", using: :btree
  add_index "team_data", ["past_team_id"], name: "index_team_data_on_past_team_id", using: :btree

  create_table "teams", force: true do |t|
    t.string   "name"
    t.string   "abbr"
    t.string   "city"
    t.integer  "yesterday_team_id"
    t.integer  "today_team_id"
    t.integer  "tomorrow_team_id"
    t.boolean  "yesterday"
    t.boolean  "today"
    t.boolean  "tomorrow"
    t.integer  "G"
    t.integer  "PTS"
    t.float    "FGP",               limit: 24
    t.float    "ThPP",              limit: 24
    t.integer  "ThPA"
    t.float    "opp_ThPP",          limit: 24
    t.integer  "opp_ThPA"
    t.float    "pace",              limit: 24
    t.integer  "rank"
    t.integer  "home_G",                       default: 0
    t.float    "home_FG",           limit: 24, default: 0.0
    t.float    "home_FGA",          limit: 24, default: 0.0
    t.float    "home_FTA",          limit: 24, default: 0.0
    t.float    "home_TOV",          limit: 24, default: 0.0
    t.float    "home_PTS",          limit: 24, default: 0.0
    t.float    "home_opp_FG",       limit: 24, default: 0.0
    t.float    "home_opp_FGA",      limit: 24, default: 0.0
    t.float    "home_opp_FTA",      limit: 24, default: 0.0
    t.float    "home_opp_TOV",      limit: 24, default: 0.0
    t.float    "home_opp_PTS",      limit: 24, default: 0.0
    t.integer  "away_G",                       default: 0
    t.float    "away_FG",           limit: 24, default: 0.0
    t.float    "away_FGA",          limit: 24, default: 0.0
    t.float    "away_FTA",          limit: 24, default: 0.0
    t.float    "away_TOV",          limit: 24, default: 0.0
    t.float    "away_PTS",          limit: 24, default: 0.0
    t.float    "away_opp_FG",       limit: 24, default: 0.0
    t.float    "away_opp_FGA",      limit: 24, default: 0.0
    t.float    "away_opp_FTA",      limit: 24, default: 0.0
    t.float    "away_opp_TOV",      limit: 24, default: 0.0
    t.float    "away_opp_PTS",      limit: 24, default: 0.0
    t.integer  "sun_G",                        default: 0
    t.float    "sun_FG",            limit: 24, default: 0.0
    t.float    "sun_FGA",           limit: 24, default: 0.0
    t.float    "sun_FTA",           limit: 24, default: 0.0
    t.float    "sun_TOV",           limit: 24, default: 0.0
    t.float    "sun_PTS",           limit: 24, default: 0.0
    t.float    "sun_opp_FG",        limit: 24, default: 0.0
    t.float    "sun_opp_FGA",       limit: 24, default: 0.0
    t.float    "sun_opp_FTA",       limit: 24, default: 0.0
    t.float    "sun_opp_TOV",       limit: 24, default: 0.0
    t.float    "sun_opp_PTS",       limit: 24, default: 0.0
    t.integer  "mon_G",                        default: 0
    t.float    "mon_FG",            limit: 24, default: 0.0
    t.float    "mon_FGA",           limit: 24, default: 0.0
    t.float    "mon_FTA",           limit: 24, default: 0.0
    t.float    "mon_TOV",           limit: 24, default: 0.0
    t.float    "mon_PTS",           limit: 24, default: 0.0
    t.float    "mon_opp_FG",        limit: 24, default: 0.0
    t.float    "mon_opp_FGA",       limit: 24, default: 0.0
    t.float    "mon_opp_FTA",       limit: 24, default: 0.0
    t.float    "mon_opp_TOV",       limit: 24, default: 0.0
    t.float    "mon_opp_PTS",       limit: 24, default: 0.0
    t.integer  "tue_G",                        default: 0
    t.float    "tue_FG",            limit: 24, default: 0.0
    t.float    "tue_FGA",           limit: 24, default: 0.0
    t.float    "tue_FTA",           limit: 24, default: 0.0
    t.float    "tue_TOV",           limit: 24, default: 0.0
    t.float    "tue_PTS",           limit: 24, default: 0.0
    t.float    "tue_opp_FG",        limit: 24, default: 0.0
    t.float    "tue_opp_FGA",       limit: 24, default: 0.0
    t.float    "tue_opp_FTA",       limit: 24, default: 0.0
    t.float    "tue_opp_TOV",       limit: 24, default: 0.0
    t.float    "tue_opp_PTS",       limit: 24, default: 0.0
    t.integer  "wed_G",                        default: 0
    t.float    "wed_FG",            limit: 24, default: 0.0
    t.float    "wed_FGA",           limit: 24, default: 0.0
    t.float    "wed_FTA",           limit: 24, default: 0.0
    t.float    "wed_TOV",           limit: 24, default: 0.0
    t.float    "wed_PTS",           limit: 24, default: 0.0
    t.float    "wed_opp_FG",        limit: 24, default: 0.0
    t.float    "wed_opp_FGA",       limit: 24, default: 0.0
    t.float    "wed_opp_FTA",       limit: 24, default: 0.0
    t.float    "wed_opp_TOV",       limit: 24, default: 0.0
    t.float    "wed_opp_PTS",       limit: 24, default: 0.0
    t.integer  "thu_G",                        default: 0
    t.float    "thu_FG",            limit: 24, default: 0.0
    t.float    "thu_FGA",           limit: 24, default: 0.0
    t.float    "thu_FTA",           limit: 24, default: 0.0
    t.float    "thu_TOV",           limit: 24, default: 0.0
    t.float    "thu_PTS",           limit: 24, default: 0.0
    t.float    "thu_opp_FG",        limit: 24, default: 0.0
    t.float    "thu_opp_FGA",       limit: 24, default: 0.0
    t.float    "thu_opp_FTA",       limit: 24, default: 0.0
    t.float    "thu_opp_TOV",       limit: 24, default: 0.0
    t.float    "thu_opp_PTS",       limit: 24, default: 0.0
    t.integer  "fri_G",                        default: 0
    t.float    "fri_FG",            limit: 24, default: 0.0
    t.float    "fri_FGA",           limit: 24, default: 0.0
    t.float    "fri_FTA",           limit: 24, default: 0.0
    t.float    "fri_TOV",           limit: 24, default: 0.0
    t.float    "fri_PTS",           limit: 24, default: 0.0
    t.float    "fri_opp_FG",        limit: 24, default: 0.0
    t.float    "fri_opp_FGA",       limit: 24, default: 0.0
    t.float    "fri_opp_FTA",       limit: 24, default: 0.0
    t.float    "fri_opp_TOV",       limit: 24, default: 0.0
    t.float    "fri_opp_PTS",       limit: 24, default: 0.0
    t.integer  "sat_G",                        default: 0
    t.float    "sat_FG",            limit: 24, default: 0.0
    t.float    "sat_FGA",           limit: 24, default: 0.0
    t.float    "sat_FTA",           limit: 24, default: 0.0
    t.float    "sat_TOV",           limit: 24, default: 0.0
    t.float    "sat_PTS",           limit: 24, default: 0.0
    t.float    "sat_opp_FG",        limit: 24, default: 0.0
    t.float    "sat_opp_FGA",       limit: 24, default: 0.0
    t.float    "sat_opp_FTA",       limit: 24, default: 0.0
    t.float    "sat_opp_TOV",       limit: 24, default: 0.0
    t.float    "sat_opp_PTS",       limit: 24, default: 0.0
    t.integer  "zero_G",                       default: 0
    t.float    "zero_FG",           limit: 24, default: 0.0
    t.float    "zero_FGA",          limit: 24, default: 0.0
    t.float    "zero_FTA",          limit: 24, default: 0.0
    t.float    "zero_TOV",          limit: 24, default: 0.0
    t.float    "zero_PTS",          limit: 24, default: 0.0
    t.float    "zero_opp_FG",       limit: 24, default: 0.0
    t.float    "zero_opp_FGA",      limit: 24, default: 0.0
    t.float    "zero_opp_FTA",      limit: 24, default: 0.0
    t.float    "zero_opp_TOV",      limit: 24, default: 0.0
    t.float    "zero_opp_PTS",      limit: 24, default: 0.0
    t.integer  "one_G",                        default: 0
    t.float    "one_FG",            limit: 24, default: 0.0
    t.float    "one_FGA",           limit: 24, default: 0.0
    t.float    "one_FTA",           limit: 24, default: 0.0
    t.float    "one_TOV",           limit: 24, default: 0.0
    t.float    "one_PTS",           limit: 24, default: 0.0
    t.float    "one_opp_FG",        limit: 24, default: 0.0
    t.float    "one_opp_FGA",       limit: 24, default: 0.0
    t.float    "one_opp_FTA",       limit: 24, default: 0.0
    t.float    "one_opp_TOV",       limit: 24, default: 0.0
    t.float    "one_opp_PTS",       limit: 24, default: 0.0
    t.integer  "two_G",                        default: 0
    t.float    "two_FG",            limit: 24, default: 0.0
    t.float    "two_FGA",           limit: 24, default: 0.0
    t.float    "two_FTA",           limit: 24, default: 0.0
    t.float    "two_TOV",           limit: 24, default: 0.0
    t.float    "two_PTS",           limit: 24, default: 0.0
    t.float    "two_opp_FG",        limit: 24, default: 0.0
    t.float    "two_opp_FGA",       limit: 24, default: 0.0
    t.float    "two_opp_FTA",       limit: 24, default: 0.0
    t.float    "two_opp_TOV",       limit: 24, default: 0.0
    t.float    "two_opp_PTS",       limit: 24, default: 0.0
    t.integer  "three_G",                      default: 0
    t.float    "three_FG",          limit: 24, default: 0.0
    t.float    "three_FGA",         limit: 24, default: 0.0
    t.float    "three_FTA",         limit: 24, default: 0.0
    t.float    "three_TOV",         limit: 24, default: 0.0
    t.float    "three_PTS",         limit: 24, default: 0.0
    t.float    "three_opp_FG",      limit: 24, default: 0.0
    t.float    "three_opp_FGA",     limit: 24, default: 0.0
    t.float    "three_opp_FTA",     limit: 24, default: 0.0
    t.float    "three_opp_TOV",     limit: 24, default: 0.0
    t.float    "three_opp_PTS",     limit: 24, default: 0.0
    t.integer  "today_G",                      default: 0
    t.float    "today_FG",          limit: 24, default: 0.0
    t.float    "today_FGA",         limit: 24, default: 0.0
    t.float    "today_FTA",         limit: 24, default: 0.0
    t.float    "today_TOV",         limit: 24, default: 0.0
    t.float    "today_PTS",         limit: 24, default: 0.0
    t.float    "today_opp_FG",      limit: 24, default: 0.0
    t.float    "today_opp_FGA",     limit: 24, default: 0.0
    t.float    "today_opp_FTA",     limit: 24, default: 0.0
    t.float    "today_opp_TOV",     limit: 24, default: 0.0
    t.float    "today_opp_PTS",     limit: 24, default: 0.0
    t.integer  "tomorrow_G",                   default: 0
    t.float    "tomorrow_FG",       limit: 24, default: 0.0
    t.float    "tomorrow_FGA",      limit: 24, default: 0.0
    t.float    "tomorrow_FTA",      limit: 24, default: 0.0
    t.float    "tomorrow_TOV",      limit: 24, default: 0.0
    t.float    "tomorrow_PTS",      limit: 24, default: 0.0
    t.float    "tomorrow_opp_FG",   limit: 24, default: 0.0
    t.float    "tomorrow_opp_FGA",  limit: 24, default: 0.0
    t.float    "tomorrow_opp_FTA",  limit: 24, default: 0.0
    t.float    "tomorrow_opp_TOV",  limit: 24, default: 0.0
    t.float    "tomorrow_opp_PTS",  limit: 24, default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "latitude",          limit: 24
    t.float    "longitude",         limit: 24
  end

  add_index "teams", ["abbr"], name: "index_teams_on_abbr", using: :btree
  add_index "teams", ["city"], name: "index_teams_on_city", using: :btree
  add_index "teams", ["name"], name: "index_teams_on_name", using: :btree

  create_table "users", force: true do |t|
    t.string   "username"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end

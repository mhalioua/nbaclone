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

ActiveRecord::Schema.define(version: 20141028033011) do

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
    t.integer  "ORtg"
    t.integer  "DRtg"
    t.float    "eFG",               limit: 24
    t.float    "TS",                limit: 24
    t.float    "MP_1",              limit: 24
    t.float    "MP_2",              limit: 24
    t.float    "MP_3",              limit: 24
    t.float    "MP_4",              limit: 24
    t.float    "MP_5",              limit: 24
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

  add_index "players", ["name"], name: "index_players_on_name", using: :btree

  create_table "teams", force: true do |t|
    t.string   "name"
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
    t.integer  "home_G"
    t.integer  "home_W"
    t.integer  "home_L"
    t.float    "home_FG",           limit: 24
    t.float    "home_FGA",          limit: 24
    t.float    "home_ThP",          limit: 24
    t.float    "home_ThPA",         limit: 24
    t.float    "home_FT",           limit: 24
    t.float    "home_FTA",          limit: 24
    t.float    "home_ORB",          limit: 24
    t.float    "home_TRB",          limit: 24
    t.float    "home_AST",          limit: 24
    t.float    "home_STL",          limit: 24
    t.float    "home_BLK",          limit: 24
    t.float    "home_TOV",          limit: 24
    t.float    "home_PF",           limit: 24
    t.float    "home_PTS",          limit: 24
    t.float    "home_opp_FG",       limit: 24
    t.float    "home_opp_FGA",      limit: 24
    t.float    "home_opp_ThP",      limit: 24
    t.float    "home_opp_ThPA",     limit: 24
    t.float    "home_opp_FT",       limit: 24
    t.float    "home_opp_FTA",      limit: 24
    t.float    "home_opp_ORB",      limit: 24
    t.float    "home_opp_TRB",      limit: 24
    t.float    "home_opp_AST",      limit: 24
    t.float    "home_opp_STL",      limit: 24
    t.float    "home_opp_BLK",      limit: 24
    t.float    "home_opp_TOV",      limit: 24
    t.float    "home_opp_PF",       limit: 24
    t.float    "home_opp_PTS",      limit: 24
    t.integer  "away_G"
    t.integer  "away_W"
    t.integer  "away_L"
    t.float    "away_FG",           limit: 24
    t.float    "away_FGA",          limit: 24
    t.float    "away_ThP",          limit: 24
    t.float    "away_ThPA",         limit: 24
    t.float    "away_FT",           limit: 24
    t.float    "away_FTA",          limit: 24
    t.float    "away_ORB",          limit: 24
    t.float    "away_TRB",          limit: 24
    t.float    "away_AST",          limit: 24
    t.float    "away_STL",          limit: 24
    t.float    "away_BLK",          limit: 24
    t.float    "away_TOV",          limit: 24
    t.float    "away_PF",           limit: 24
    t.float    "away_PTS",          limit: 24
    t.float    "away_opp_FG",       limit: 24
    t.float    "away_opp_FGA",      limit: 24
    t.float    "away_opp_ThP",      limit: 24
    t.float    "away_opp_ThPA",     limit: 24
    t.float    "away_opp_FT",       limit: 24
    t.float    "away_opp_FTA",      limit: 24
    t.float    "away_opp_ORB",      limit: 24
    t.float    "away_opp_TRB",      limit: 24
    t.float    "away_opp_AST",      limit: 24
    t.float    "away_opp_STL",      limit: 24
    t.float    "away_opp_BLK",      limit: 24
    t.float    "away_opp_TOV",      limit: 24
    t.float    "away_opp_PF",       limit: 24
    t.float    "away_opp_PTS",      limit: 24
    t.integer  "sun_G"
    t.integer  "sun_W"
    t.integer  "sun_L"
    t.float    "sun_FG",            limit: 24
    t.float    "sun_FGA",           limit: 24
    t.float    "sun_ThP",           limit: 24
    t.float    "sun_ThPA",          limit: 24
    t.float    "sun_FT",            limit: 24
    t.float    "sun_FTA",           limit: 24
    t.float    "sun_ORB",           limit: 24
    t.float    "sun_TRB",           limit: 24
    t.float    "sun_AST",           limit: 24
    t.float    "sun_STL",           limit: 24
    t.float    "sun_BLK",           limit: 24
    t.float    "sun_TOV",           limit: 24
    t.float    "sun_PF",            limit: 24
    t.float    "sun_PTS",           limit: 24
    t.float    "sun_opp_FG",        limit: 24
    t.float    "sun_opp_FGA",       limit: 24
    t.float    "sun_opp_ThP",       limit: 24
    t.float    "sun_opp_ThPA",      limit: 24
    t.float    "sun_opp_FT",        limit: 24
    t.float    "sun_opp_FTA",       limit: 24
    t.float    "sun_opp_ORB",       limit: 24
    t.float    "sun_opp_TRB",       limit: 24
    t.float    "sun_opp_AST",       limit: 24
    t.float    "sun_opp_STL",       limit: 24
    t.float    "sun_opp_BLK",       limit: 24
    t.float    "sun_opp_TOV",       limit: 24
    t.float    "sun_opp_PF",        limit: 24
    t.float    "sun_opp_PTS",       limit: 24
    t.integer  "mon_G"
    t.integer  "mon_W"
    t.integer  "mon_L"
    t.float    "mon_FG",            limit: 24
    t.float    "mon_FGA",           limit: 24
    t.float    "mon_ThP",           limit: 24
    t.float    "mon_ThPA",          limit: 24
    t.float    "mon_FT",            limit: 24
    t.float    "mon_FTA",           limit: 24
    t.float    "mon_ORB",           limit: 24
    t.float    "mon_TRB",           limit: 24
    t.float    "mon_AST",           limit: 24
    t.float    "mon_STL",           limit: 24
    t.float    "mon_BLK",           limit: 24
    t.float    "mon_TOV",           limit: 24
    t.float    "mon_PF",            limit: 24
    t.float    "mon_PTS",           limit: 24
    t.float    "mon_opp_FG",        limit: 24
    t.float    "mon_opp_FGA",       limit: 24
    t.float    "mon_opp_ThP",       limit: 24
    t.float    "mon_opp_ThPA",      limit: 24
    t.float    "mon_opp_FT",        limit: 24
    t.float    "mon_opp_FTA",       limit: 24
    t.float    "mon_opp_ORB",       limit: 24
    t.float    "mon_opp_TRB",       limit: 24
    t.float    "mon_opp_AST",       limit: 24
    t.float    "mon_opp_STL",       limit: 24
    t.float    "mon_opp_BLK",       limit: 24
    t.float    "mon_opp_TOV",       limit: 24
    t.float    "mon_opp_PF",        limit: 24
    t.float    "mon_opp_PTS",       limit: 24
    t.integer  "tue_G"
    t.integer  "tue_W"
    t.integer  "tue_L"
    t.float    "tue_FG",            limit: 24
    t.float    "tue_FGA",           limit: 24
    t.float    "tue_ThP",           limit: 24
    t.float    "tue_ThPA",          limit: 24
    t.float    "tue_FT",            limit: 24
    t.float    "tue_FTA",           limit: 24
    t.float    "tue_ORB",           limit: 24
    t.float    "tue_TRB",           limit: 24
    t.float    "tue_AST",           limit: 24
    t.float    "tue_STL",           limit: 24
    t.float    "tue_BLK",           limit: 24
    t.float    "tue_TOV",           limit: 24
    t.float    "tue_PF",            limit: 24
    t.float    "tue_PTS",           limit: 24
    t.float    "tue_opp_FG",        limit: 24
    t.float    "tue_opp_FGA",       limit: 24
    t.float    "tue_opp_ThP",       limit: 24
    t.float    "tue_opp_ThPA",      limit: 24
    t.float    "tue_opp_FT",        limit: 24
    t.float    "tue_opp_FTA",       limit: 24
    t.float    "tue_opp_ORB",       limit: 24
    t.float    "tue_opp_TRB",       limit: 24
    t.float    "tue_opp_AST",       limit: 24
    t.float    "tue_opp_STL",       limit: 24
    t.float    "tue_opp_BLK",       limit: 24
    t.float    "tue_opp_TOV",       limit: 24
    t.float    "tue_opp_PF",        limit: 24
    t.float    "tue_opp_PTS",       limit: 24
    t.integer  "wed_G"
    t.integer  "wed_W"
    t.integer  "wed_L"
    t.float    "wed_FG",            limit: 24
    t.float    "wed_FGA",           limit: 24
    t.float    "wed_ThP",           limit: 24
    t.float    "wed_ThPA",          limit: 24
    t.float    "wed_FT",            limit: 24
    t.float    "wed_FTA",           limit: 24
    t.float    "wed_ORB",           limit: 24
    t.float    "wed_TRB",           limit: 24
    t.float    "wed_AST",           limit: 24
    t.float    "wed_STL",           limit: 24
    t.float    "wed_BLK",           limit: 24
    t.float    "wed_TOV",           limit: 24
    t.float    "wed_PF",            limit: 24
    t.float    "wed_PTS",           limit: 24
    t.float    "wed_opp_FG",        limit: 24
    t.float    "wed_opp_FGA",       limit: 24
    t.float    "wed_opp_ThP",       limit: 24
    t.float    "wed_opp_ThPA",      limit: 24
    t.float    "wed_opp_FT",        limit: 24
    t.float    "wed_opp_FTA",       limit: 24
    t.float    "wed_opp_ORB",       limit: 24
    t.float    "wed_opp_TRB",       limit: 24
    t.float    "wed_opp_AST",       limit: 24
    t.float    "wed_opp_STL",       limit: 24
    t.float    "wed_opp_BLK",       limit: 24
    t.float    "wed_opp_TOV",       limit: 24
    t.float    "wed_opp_PF",        limit: 24
    t.float    "wed_opp_PTS",       limit: 24
    t.integer  "thu_G"
    t.integer  "thu_W"
    t.integer  "thu_L"
    t.float    "thu_FG",            limit: 24
    t.float    "thu_FGA",           limit: 24
    t.float    "thu_ThP",           limit: 24
    t.float    "thu_ThPA",          limit: 24
    t.float    "thu_FT",            limit: 24
    t.float    "thu_FTA",           limit: 24
    t.float    "thu_ORB",           limit: 24
    t.float    "thu_TRB",           limit: 24
    t.float    "thu_AST",           limit: 24
    t.float    "thu_STL",           limit: 24
    t.float    "thu_BLK",           limit: 24
    t.float    "thu_TOV",           limit: 24
    t.float    "thu_PF",            limit: 24
    t.float    "thu_PTS",           limit: 24
    t.float    "thu_opp_FG",        limit: 24
    t.float    "thu_opp_FGA",       limit: 24
    t.float    "thu_opp_ThP",       limit: 24
    t.float    "thu_opp_ThPA",      limit: 24
    t.float    "thu_opp_FT",        limit: 24
    t.float    "thu_opp_FTA",       limit: 24
    t.float    "thu_opp_ORB",       limit: 24
    t.float    "thu_opp_TRB",       limit: 24
    t.float    "thu_opp_AST",       limit: 24
    t.float    "thu_opp_STL",       limit: 24
    t.float    "thu_opp_BLK",       limit: 24
    t.float    "thu_opp_TOV",       limit: 24
    t.float    "thu_opp_PF",        limit: 24
    t.float    "thu_opp_PTS",       limit: 24
    t.integer  "fri_G"
    t.integer  "fri_W"
    t.integer  "fri_L"
    t.float    "fri_FG",            limit: 24
    t.float    "fri_FGA",           limit: 24
    t.float    "fri_ThP",           limit: 24
    t.float    "fri_ThPA",          limit: 24
    t.float    "fri_FT",            limit: 24
    t.float    "fri_FTA",           limit: 24
    t.float    "fri_ORB",           limit: 24
    t.float    "fri_TRB",           limit: 24
    t.float    "fri_AST",           limit: 24
    t.float    "fri_STL",           limit: 24
    t.float    "fri_BLK",           limit: 24
    t.float    "fri_TOV",           limit: 24
    t.float    "fri_PF",            limit: 24
    t.float    "fri_PTS",           limit: 24
    t.float    "fri_opp_FG",        limit: 24
    t.float    "fri_opp_FGA",       limit: 24
    t.float    "fri_opp_ThP",       limit: 24
    t.float    "fri_opp_ThPA",      limit: 24
    t.float    "fri_opp_FT",        limit: 24
    t.float    "fri_opp_FTA",       limit: 24
    t.float    "fri_opp_ORB",       limit: 24
    t.float    "fri_opp_TRB",       limit: 24
    t.float    "fri_opp_AST",       limit: 24
    t.float    "fri_opp_STL",       limit: 24
    t.float    "fri_opp_BLK",       limit: 24
    t.float    "fri_opp_TOV",       limit: 24
    t.float    "fri_opp_PF",        limit: 24
    t.float    "fri_opp_PTS",       limit: 24
    t.integer  "sat_G"
    t.integer  "sat_W"
    t.integer  "sat_L"
    t.float    "sat_FG",            limit: 24
    t.float    "sat_FGA",           limit: 24
    t.float    "sat_ThP",           limit: 24
    t.float    "sat_ThPA",          limit: 24
    t.float    "sat_FT",            limit: 24
    t.float    "sat_FTA",           limit: 24
    t.float    "sat_ORB",           limit: 24
    t.float    "sat_TRB",           limit: 24
    t.float    "sat_AST",           limit: 24
    t.float    "sat_STL",           limit: 24
    t.float    "sat_BLK",           limit: 24
    t.float    "sat_TOV",           limit: 24
    t.float    "sat_PF",            limit: 24
    t.float    "sat_PTS",           limit: 24
    t.float    "sat_opp_FG",        limit: 24
    t.float    "sat_opp_FGA",       limit: 24
    t.float    "sat_opp_ThP",       limit: 24
    t.float    "sat_opp_ThPA",      limit: 24
    t.float    "sat_opp_FT",        limit: 24
    t.float    "sat_opp_FTA",       limit: 24
    t.float    "sat_opp_ORB",       limit: 24
    t.float    "sat_opp_TRB",       limit: 24
    t.float    "sat_opp_AST",       limit: 24
    t.float    "sat_opp_STL",       limit: 24
    t.float    "sat_opp_BLK",       limit: 24
    t.float    "sat_opp_TOV",       limit: 24
    t.float    "sat_opp_PF",        limit: 24
    t.float    "sat_opp_PTS",       limit: 24
    t.integer  "zero_G"
    t.integer  "zero_W"
    t.integer  "zero_L"
    t.float    "zero_FG",           limit: 24
    t.float    "zero_FGA",          limit: 24
    t.float    "zero_ThP",          limit: 24
    t.float    "zero_ThPA",         limit: 24
    t.float    "zero_FT",           limit: 24
    t.float    "zero_FTA",          limit: 24
    t.float    "zero_ORB",          limit: 24
    t.float    "zero_TRB",          limit: 24
    t.float    "zero_AST",          limit: 24
    t.float    "zero_STL",          limit: 24
    t.float    "zero_BLK",          limit: 24
    t.float    "zero_TOV",          limit: 24
    t.float    "zero_PF",           limit: 24
    t.float    "zero_PTS",          limit: 24
    t.float    "zero_opp_FG",       limit: 24
    t.float    "zero_opp_FGA",      limit: 24
    t.float    "zero_opp_ThP",      limit: 24
    t.float    "zero_opp_ThPA",     limit: 24
    t.float    "zero_opp_FT",       limit: 24
    t.float    "zero_opp_FTA",      limit: 24
    t.float    "zero_opp_ORB",      limit: 24
    t.float    "zero_opp_TRB",      limit: 24
    t.float    "zero_opp_AST",      limit: 24
    t.float    "zero_opp_STL",      limit: 24
    t.float    "zero_opp_BLK",      limit: 24
    t.float    "zero_opp_TOV",      limit: 24
    t.float    "zero_opp_PF",       limit: 24
    t.float    "zero_opp_PTS",      limit: 24
    t.integer  "one_G"
    t.integer  "one_W"
    t.integer  "one_L"
    t.float    "one_FG",            limit: 24
    t.float    "one_FGA",           limit: 24
    t.float    "one_ThP",           limit: 24
    t.float    "one_ThPA",          limit: 24
    t.float    "one_FT",            limit: 24
    t.float    "one_FTA",           limit: 24
    t.float    "one_ORB",           limit: 24
    t.float    "one_TRB",           limit: 24
    t.float    "one_AST",           limit: 24
    t.float    "one_STL",           limit: 24
    t.float    "one_BLK",           limit: 24
    t.float    "one_TOV",           limit: 24
    t.float    "one_PF",            limit: 24
    t.float    "one_PTS",           limit: 24
    t.float    "one_opp_FG",        limit: 24
    t.float    "one_opp_FGA",       limit: 24
    t.float    "one_opp_ThP",       limit: 24
    t.float    "one_opp_ThPA",      limit: 24
    t.float    "one_opp_FT",        limit: 24
    t.float    "one_opp_FTA",       limit: 24
    t.float    "one_opp_ORB",       limit: 24
    t.float    "one_opp_TRB",       limit: 24
    t.float    "one_opp_AST",       limit: 24
    t.float    "one_opp_STL",       limit: 24
    t.float    "one_opp_BLK",       limit: 24
    t.float    "one_opp_TOV",       limit: 24
    t.float    "one_opp_PF",        limit: 24
    t.float    "one_opp_PTS",       limit: 24
    t.integer  "two_G"
    t.integer  "two_W"
    t.integer  "two_L"
    t.float    "two_FG",            limit: 24
    t.float    "two_FGA",           limit: 24
    t.float    "two_ThP",           limit: 24
    t.float    "two_ThPA",          limit: 24
    t.float    "two_FT",            limit: 24
    t.float    "two_FTA",           limit: 24
    t.float    "two_ORB",           limit: 24
    t.float    "two_TRB",           limit: 24
    t.float    "two_AST",           limit: 24
    t.float    "two_STL",           limit: 24
    t.float    "two_BLK",           limit: 24
    t.float    "two_TOV",           limit: 24
    t.float    "two_PF",            limit: 24
    t.float    "two_PTS",           limit: 24
    t.float    "two_opp_FG",        limit: 24
    t.float    "two_opp_FGA",       limit: 24
    t.float    "two_opp_ThP",       limit: 24
    t.float    "two_opp_ThPA",      limit: 24
    t.float    "two_opp_FT",        limit: 24
    t.float    "two_opp_FTA",       limit: 24
    t.float    "two_opp_ORB",       limit: 24
    t.float    "two_opp_TRB",       limit: 24
    t.float    "two_opp_AST",       limit: 24
    t.float    "two_opp_STL",       limit: 24
    t.float    "two_opp_BLK",       limit: 24
    t.float    "two_opp_TOV",       limit: 24
    t.float    "two_opp_PF",        limit: 24
    t.float    "two_opp_PTS",       limit: 24
    t.integer  "three_G"
    t.integer  "three_W"
    t.integer  "three_L"
    t.float    "three_FG",          limit: 24
    t.float    "three_FGA",         limit: 24
    t.float    "three_ThP",         limit: 24
    t.float    "three_ThPA",        limit: 24
    t.float    "three_FT",          limit: 24
    t.float    "three_FTA",         limit: 24
    t.float    "three_ORB",         limit: 24
    t.float    "three_TRB",         limit: 24
    t.float    "three_AST",         limit: 24
    t.float    "three_STL",         limit: 24
    t.float    "three_BLK",         limit: 24
    t.float    "three_TOV",         limit: 24
    t.float    "three_PF",          limit: 24
    t.float    "three_PTS",         limit: 24
    t.float    "three_opp_FG",      limit: 24
    t.float    "three_opp_FGA",     limit: 24
    t.float    "three_opp_ThP",     limit: 24
    t.float    "three_opp_ThPA",    limit: 24
    t.float    "three_opp_FT",      limit: 24
    t.float    "three_opp_FTA",     limit: 24
    t.float    "three_opp_ORB",     limit: 24
    t.float    "three_opp_TRB",     limit: 24
    t.float    "three_opp_AST",     limit: 24
    t.float    "three_opp_STL",     limit: 24
    t.float    "three_opp_BLK",     limit: 24
    t.float    "three_opp_TOV",     limit: 24
    t.float    "three_opp_PF",      limit: 24
    t.float    "three_opp_PTS",     limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "teams", ["name"], name: "index_teams_on_name", using: :btree

  create_table "users", force: true do |t|
    t.string   "username"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end

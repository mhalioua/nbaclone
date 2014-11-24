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
    t.string   "MP"
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
    t.boolean  "starter",               default: false
    t.string   "name"
    t.string   "alias"
    t.string   "height"
    t.string   "position"
    t.boolean  "forward",               default: false
    t.boolean  "guard",                 default: false
    t.integer  "GS"
    t.integer  "MP"
    t.integer  "FG"
    t.integer  "FGA"
    t.float    "FGP",        limit: 24
    t.integer  "ThP"
    t.integer  "ThPA"
    t.float    "ThPP",       limit: 24
    t.integer  "FT"
    t.integer  "FTA"
    t.float    "FTP",        limit: 24
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

  add_index "players", ["name"], name: "index_players_on_name", using: :btree

  create_table "teams", force: true do |t|
    t.string   "name"
    t.string   "city"
    t.boolean  "yesterday"
    t.boolean  "today"
    t.boolean  "tomorrow"
    t.string   "opp_yesterday"
    t.string   "opp_today"
    t.string   "opp_tomorrow"
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

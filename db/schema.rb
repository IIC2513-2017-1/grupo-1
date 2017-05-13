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

ActiveRecord::Schema.define(version: 20170513175220) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bets", force: :cascade do |t|
    t.string   "sport"
    t.datetime "start_date"
    t.string   "country"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.float    "pay_per_tie"
    t.string   "tournament"
  end

  create_table "bets_competitors", id: false, force: :cascade do |t|
    t.integer "competitor_id", null: false
    t.integer "bet_id",        null: false
    t.float   "multiplicator"
    t.integer "local"
    t.index ["bet_id"], name: "index_bets_competitors_on_bet_id", using: :btree
    t.index ["competitor_id", "bet_id"], name: "index_bets_competitors_on_competitor_id_and_bet_id", unique: true, using: :btree
    t.index ["competitor_id"], name: "index_bets_competitors_on_competitor_id", using: :btree
  end

  create_table "bets_grands", id: false, force: :cascade do |t|
    t.integer "grand_id",  null: false
    t.integer "bet_id",    null: false
    t.string  "selection"
    t.index ["bet_id"], name: "index_bets_grands_on_bet_id", using: :btree
    t.index ["grand_id", "bet_id"], name: "index_bets_grands_on_grand_id_and_bet_id", unique: true, using: :btree
    t.index ["grand_id"], name: "index_bets_grands_on_grand_id", using: :btree
  end

  create_table "competitors", force: :cascade do |t|
    t.string   "name"
    t.string   "country"
    t.string   "sport"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "grands", force: :cascade do |t|
    t.integer  "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "end_date"
    t.integer  "user_id"
    t.index ["user_id"], name: "index_grands_on_user_id", using: :btree
  end

  create_table "make_ups", force: :cascade do |t|
    t.integer  "bet_id"
    t.integer  "grand_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "selection"
    t.index ["grand_id", "bet_id"], name: "index_make_ups_on_grand_id_and_bet_id", unique: true, using: :btree
  end

  create_table "parts", force: :cascade do |t|
    t.integer  "competitor_id"
    t.integer  "bet_id"
    t.float    "multiplicator"
    t.integer  "local"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["competitor_id", "bet_id"], name: "index_parts_on_competitor_id_and_bet_id", unique: true, using: :btree
  end

  create_table "pending_relationships", force: :cascade do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["followed_id"], name: "index_pending_relationships_on_followed_id", using: :btree
    t.index ["follower_id", "followed_id"], name: "index_pending_relationships_on_follower_id_and_followed_id", unique: true, using: :btree
    t.index ["follower_id"], name: "index_pending_relationships_on_follower_id", using: :btree
  end

  create_table "relationships", force: :cascade do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["followed_id"], name: "index_relationships_on_followed_id", using: :btree
    t.index ["follower_id", "followed_id"], name: "index_relationships_on_follower_id_and_followed_id", unique: true, using: :btree
    t.index ["follower_id"], name: "index_relationships_on_follower_id", using: :btree
  end

  create_table "user_bets", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "user_id"
    t.integer  "challenger_amount"
    t.integer  "gambler_amount"
    t.integer  "bet_limit"
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["user_id"], name: "index_user_bets_on_user_id", using: :btree
  end

  create_table "user_user_bets", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "user_bet_id"
    t.index ["user_bet_id"], name: "index_user_user_bets_on_user_bet_id", using: :btree
    t.index ["user_id"], name: "index_user_user_bets_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "role"
    t.string   "email"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "password_digest"
    t.string   "name"
    t.string   "lastname"
    t.string   "description"
    t.integer  "money"
    t.date     "birthday"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["username"], name: "index_users_on_username", unique: true, using: :btree
  end

  add_foreign_key "grands", "users"
  add_foreign_key "user_user_bets", "user_bets"
  add_foreign_key "user_user_bets", "users"
end

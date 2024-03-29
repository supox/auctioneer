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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130828204405) do

  create_table "auction_user_relationships", :force => true do |t|
    t.integer  "auction_id"
    t.integer  "listener_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "auction_user_relationships", ["auction_id", "listener_id"], :name => "index_auction_user_relationships_on_auction_id_and_listener_id", :unique => true
  add_index "auction_user_relationships", ["auction_id"], :name => "index_auction_user_relationships_on_auction_id"
  add_index "auction_user_relationships", ["listener_id"], :name => "index_auction_user_relationships_on_listener_id"

  create_table "auctions", :force => true do |t|
    t.datetime "date_opened"
    t.datetime "date_closed"
    t.integer  "item_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "bids", :force => true do |t|
    t.datetime "offer_date"
    t.decimal  "value"
    t.boolean  "withraw",    :default => false
    t.integer  "auction_id"
    t.integer  "user_id"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "items", :force => true do |t|
    t.string   "description"
    t.integer  "auction_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "phone"
    t.string   "password_digest"
    t.boolean  "admin",                  :default => false
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.string   "remember_token"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end

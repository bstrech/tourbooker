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

ActiveRecord::Schema.define(:version => 20140131032845) do

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "token"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone"
    t.string   "ip_address"
    t.date     "preferred_tour_date"
    t.boolean  "amn_pool"
    t.boolean  "amn_rec_room"
    t.boolean  "amn_movie_theater"
    t.boolean  "amn_doctor"
    t.boolean  "amn_time_machine"
    t.integer  "rating"
    t.string   "aasm_state",          :default => "new"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email"

end

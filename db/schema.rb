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

ActiveRecord::Schema.define(version: 20140318074105) do

  create_table "langs", force: true do |t|
    t.string   "name"
    t.string   "value"
    t.integer  "order_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "snippets", force: true do |t|
    t.text     "snippet"
    t.integer  "lang_id"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "snippets", ["lang_id"], name: "index_snippets_on_lang_id"

end

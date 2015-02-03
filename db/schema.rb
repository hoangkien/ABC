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

ActiveRecord::Schema.define(version: 20150203061536) do

  create_table "companies", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "address",    limit: 255
    t.string   "code",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "devices", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.boolean  "status",     limit: 1
    t.string   "lat",        limit: 255
    t.string   "lng",        limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "code",       limit: 255
    t.integer  "company_id", limit: 4
  end

  create_table "feedbacks", force: :cascade do |t|
    t.string   "quantiy_service", limit: 255
    t.string   "comment",         limit: 255
    t.integer  "traveller_id",    limit: 4
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "tourguides", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "address",    limit: 255
    t.string   "phone",      limit: 255
    t.integer  "device_id",  limit: 4
    t.boolean  "active",     limit: 1
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "tourguides_tours", id: false, force: :cascade do |t|
    t.integer  "tour_id",      limit: 4, null: false
    t.integer  "tourguide_id", limit: 4, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "tours", force: :cascade do |t|
    t.string   "name",             limit: 255
    t.integer  "number_of_member", limit: 4
    t.string   "information",      limit: 255
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "tours_travellers", id: false, force: :cascade do |t|
    t.integer  "tour_id",      limit: 4, null: false
    t.integer  "traveller_id", limit: 4, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "travellers", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "address",    limit: 255
    t.string   "phone",      limit: 255
    t.integer  "device_id",  limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "account",    limit: 255
    t.string   "password",   limit: 255
    t.string   "name",       limit: 255
    t.string   "address",    limit: 255
    t.string   "group",      limit: 255
    t.string   "comp_name",  limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "company_id", limit: 4
  end

end

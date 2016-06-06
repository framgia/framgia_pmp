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

ActiveRecord::Schema.define(version: 20160526041630) do

  create_table "activities", force: :cascade do |t|
    t.integer  "product_backlog_id", limit: 4
    t.string   "subject",            limit: 255
    t.string   "description",        limit: 255
    t.integer  "spent_time",         limit: 4
    t.integer  "estimate",           limit: 4
    t.integer  "user_id",            limit: 4
    t.integer  "sprint_id",          limit: 4
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "assignees", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.integer  "project_id", limit: 4
    t.integer  "work_hour",  limit: 4
    t.integer  "sprint_id",  limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "cells", force: :cascade do |t|
    t.integer  "sheet_id",   limit: 4
    t.integer  "column_id",  limit: 4
    t.integer  "row_id",     limit: 4
    t.string   "data",       limit: 255
    t.string   "style",      limit: 255
    t.string   "parsed",     limit: 255
    t.string   "calc",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "cells", ["sheet_id"], name: "index_cells_on_sheet_id", using: :btree

  create_table "headers", force: :cascade do |t|
    t.integer  "sheet_id",   limit: 4
    t.integer  "column_id",  limit: 4
    t.string   "label",      limit: 255
    t.integer  "width",      limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "headers", ["sheet_id"], name: "index_headers_on_sheet_id", using: :btree

  create_table "log_works", force: :cascade do |t|
    t.integer  "activity_id",      limit: 4
    t.integer  "remaining_time",   limit: 4
    t.integer  "sprint_id",        limit: 4
    t.integer  "master_sprint_id", limit: 4
    t.integer  "day",              limit: 4
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "log_works", ["activity_id"], name: "index_log_works_on_activity_id", using: :btree
  add_index "log_works", ["master_sprint_id"], name: "index_log_works_on_master_sprint_id", using: :btree
  add_index "log_works", ["sprint_id"], name: "index_log_works_on_sprint_id", using: :btree

  create_table "master_sprints", force: :cascade do |t|
    t.integer "day",       limit: 4
    t.date    "date"
    t.integer "sprint_id", limit: 4
  end

  add_index "master_sprints", ["sprint_id"], name: "index_master_sprints_on_sprint_id", using: :btree

  create_table "phases", force: :cascade do |t|
    t.string   "phase_name",  limit: 255
    t.string   "description", limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "product_backlogs", force: :cascade do |t|
    t.string   "category",   limit: 255
    t.string   "story",      limit: 255
    t.integer  "priority",   limit: 4
    t.float    "estimate",   limit: 24
    t.float    "actual",     limit: 24
    t.float    "remaining",  limit: 24
    t.integer  "project_id", limit: 4
    t.integer  "sprint_id",  limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "product_backlogs", ["project_id"], name: "index_product_backlogs_on_project_id", using: :btree
  add_index "product_backlogs", ["sprint_id"], name: "index_product_backlogs_on_sprint_id", using: :btree

  create_table "projects", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.text     "description", limit: 65535
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "manager_id",  limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "sheets", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.string   "name",       limit: 255
    t.string   "key",        limit: 255
    t.string   "cfg",        limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "sheets", ["user_id"], name: "index_sheets_on_user_id", using: :btree

  create_table "sprints", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.string   "description",     limit: 255
    t.date     "start_date"
    t.integer  "work_day",        limit: 4
    t.integer  "total_lost_hour", limit: 4
    t.integer  "work_hour",       limit: 4
    t.integer  "project_id",      limit: 4
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "sprints", ["project_id"], name: "index_sprints_on_project_id", using: :btree

  create_table "system_logs", force: :cascade do |t|
    t.string   "description", limit: 255
    t.integer  "user_id",     limit: 4
    t.string   "action_type", limit: 255
    t.integer  "target_id",   limit: 4
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "time_logs", force: :cascade do |t|
    t.integer  "assignee_id",      limit: 4
    t.integer  "sprint_id",        limit: 4
    t.integer  "master_sprint_id", limit: 4
    t.integer  "lost_hour",        limit: 4
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "time_logs", ["master_sprint_id"], name: "index_time_logs_on_master_sprint_id", using: :btree
  add_index "time_logs", ["sprint_id"], name: "index_time_logs_on_sprint_id", using: :btree

  create_table "triggers", force: :cascade do |t|
    t.integer  "sheet_id",   limit: 4
    t.string   "trigger",    limit: 255
    t.string   "source",     limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "triggers", ["sheet_id"], name: "index_triggers_on_sheet_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "name",                   limit: 255, default: "", null: false
    t.integer  "role",                   limit: 4,   default: 0
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "hr_token",               limit: 255
    t.string   "hr_email",               limit: 255
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "work_performances", force: :cascade do |t|
    t.integer  "phase_id",    limit: 4
    t.string   "description", limit: 255
    t.integer  "plan",        limit: 4
    t.integer  "actual",      limit: 4
    t.integer  "activity_id", limit: 4
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "work_performances", ["phase_id"], name: "index_work_performances_on_phase_id", using: :btree

  add_foreign_key "cells", "sheets"
  add_foreign_key "headers", "sheets"
  add_foreign_key "log_works", "activities"
  add_foreign_key "sheets", "users"
  add_foreign_key "triggers", "sheets"
end

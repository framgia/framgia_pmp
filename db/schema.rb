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

ActiveRecord::Schema.define(version: 20170124030022) do

  create_table "assignees", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.integer  "project_id", limit: 4
    t.integer  "work_hour",  limit: 4
    t.integer  "sprint_id",  limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "member_id",  limit: 4
    t.string   "user_name",  limit: 255
  end

  create_table "item_performances", force: :cascade do |t|
    t.integer  "performance_name", limit: 4
    t.text     "description",      limit: 65535
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.float    "chart_type",       limit: 24
  end

  create_table "log_works", force: :cascade do |t|
    t.integer  "task_id",          limit: 4
    t.integer  "remaining_time",   limit: 4
    t.integer  "sprint_id",        limit: 4
    t.integer  "master_sprint_id", limit: 4
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "log_works", ["master_sprint_id"], name: "index_log_works_on_master_sprint_id", using: :btree
  add_index "log_works", ["sprint_id"], name: "index_log_works_on_sprint_id", using: :btree
  add_index "log_works", ["task_id"], name: "index_log_works_on_task_id", using: :btree

  create_table "master_sprints", force: :cascade do |t|
    t.integer "day",       limit: 4
    t.date    "date"
    t.integer "sprint_id", limit: 4
  end

  add_index "master_sprints", ["sprint_id"], name: "index_master_sprints_on_sprint_id", using: :btree

  create_table "phase_items", force: :cascade do |t|
    t.integer  "phase_id",            limit: 4
    t.integer  "item_performance_id", limit: 4
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.boolean  "visible"
    t.string   "alias",               limit: 255
  end

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
    t.integer  "estimate",   limit: 4
    t.float    "actual",     limit: 24
    t.float    "remaining",  limit: 24
    t.integer  "project_id", limit: 4
    t.integer  "sprint_id",  limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "story_id",   limit: 255
  end

  add_index "product_backlogs", ["project_id"], name: "index_product_backlogs_on_project_id", using: :btree
  add_index "product_backlogs", ["sprint_id"], name: "index_product_backlogs_on_sprint_id", using: :btree

  create_table "project_members", force: :cascade do |t|
    t.string   "user_name",  limit: 255
    t.integer  "user_id",    limit: 4
    t.integer  "project_id", limit: 4
    t.integer  "role",       limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "project_phases", force: :cascade do |t|
    t.integer  "project_id", limit: 4
    t.integer  "phase_id",   limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "phase_name", limit: 255
  end

  create_table "projects", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.text     "description", limit: 65535
    t.date     "start_date"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "status",      limit: 4
  end

  create_table "sprints", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.string   "description",     limit: 255
    t.date     "start_date"
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

  create_table "tasks", force: :cascade do |t|
    t.integer  "product_backlog_id", limit: 4
    t.integer  "sprint_id",          limit: 4
    t.string   "task_id",            limit: 255
    t.integer  "user_id",            limit: 4
    t.integer  "estimate",           limit: 4
    t.integer  "spent_time",         limit: 4
    t.string   "description",        limit: 255
    t.string   "subject",            limit: 255
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
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
    t.boolean  "is_root"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "work_performances", force: :cascade do |t|
    t.integer  "phase_id",            limit: 4
    t.string   "description",         limit: 255
    t.integer  "task_id",             limit: 4
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "sprint_id",           limit: 4
    t.integer  "item_performance_id", limit: 4
    t.integer  "master_sprint_id",    limit: 4
    t.float    "performance_value",   limit: 24
  end

  add_index "work_performances", ["item_performance_id"], name: "fk_rails_dec164a722", using: :btree
  add_index "work_performances", ["master_sprint_id"], name: "fk_rails_d40e64dd85", using: :btree
  add_index "work_performances", ["phase_id", "sprint_id", "task_id", "master_sprint_id"], name: "work_perormance_index", unique: true, using: :btree
  add_index "work_performances", ["phase_id"], name: "index_work_performances_on_phase_id", using: :btree
  add_index "work_performances", ["sprint_id"], name: "index_work_performances_on_sprint_id", using: :btree

  add_foreign_key "log_works", "tasks"
  add_foreign_key "work_performances", "item_performances"
  add_foreign_key "work_performances", "master_sprints"
  add_foreign_key "work_performances", "sprints"
end

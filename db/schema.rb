# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_01_12_043132) do

  create_table "deco_errors", force: :cascade do |t|
    t.text "title"
    t.boolean "read"
    t.text "priority"
    t.text "error_type"
    t.text "date"
    t.text "site_url"
    t.text "controller"
    t.text "action"
    t.text "hostname"
    t.text "remote_ip"
    t.text "request_id"
    t.text "request_log"
    t.text "parameters"
    t.text "session_id"
    t.text "rails_env"
    t.text "release"
    t.text "environment_variables"
    t.text "session_data"
    t.text "exception_class"
    t.text "exception_message"
    t.text "exception_stacktrace"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "filter_id", null: false
    t.index ["filter_id"], name: "index_deco_errors_on_filter_id"
  end

  create_table "filters", force: :cascade do |t|
    t.integer "folder_id", null: false
    t.text "name"
    t.integer "execution_order"
    t.text "logic"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["execution_order"], name: "index_filters_on_execution_order", unique: true
    t.index ["folder_id"], name: "index_filters_on_folder_id"
    t.index ["name"], name: "index_filters_on_name", unique: true
  end

  create_table "folders", force: :cascade do |t|
    t.text "name"
    t.integer "parent_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "user_created"
    t.index ["name"], name: "index_folders_on_name", unique: true
    t.index ["parent_id"], name: "index_folders_on_parent_id"
  end

  create_table "mappings", force: :cascade do |t|
    t.integer "folder_id", null: false
    t.integer "deco_error_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["deco_error_id"], name: "index_mappings_on_deco_error_id"
    t.index ["folder_id"], name: "index_mappings_on_folder_id"
  end

  create_table "rules", force: :cascade do |t|
    t.integer "filter_id", null: false
    t.text "field"
    t.text "value"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["filter_id"], name: "index_rules_on_filter_id"
  end

  add_foreign_key "deco_errors", "filters"
  add_foreign_key "filters", "folders"
  add_foreign_key "folders", "folders", column: "parent_id"
  add_foreign_key "mappings", "deco_errors"
  add_foreign_key "mappings", "folders"
  add_foreign_key "rules", "filters"
end

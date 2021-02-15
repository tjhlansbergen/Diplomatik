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

ActiveRecord::Schema.define(version: 2021_02_15_201758) do

  create_table "admin_users", force: :cascade do |t|
    t.string "username"
    t.string "password_digest"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "api_users", force: :cascade do |t|
    t.string "username"
    t.string "password_digest"
    t.integer "customer_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "can_add_users"
    t.index ["customer_id"], name: "index_api_users_on_customer_id"
  end

  create_table "customer_qualifications", id: false, force: :cascade do |t|
    t.integer "customer_id", null: false
    t.integer "qualification_id", null: false
    t.index ["customer_id"], name: "index_customer_qualifications_on_customer_id"
    t.index ["qualification_id"], name: "index_customer_qualifications_on_qualification_id"
  end

  create_table "customers", force: :cascade do |t|
    t.string "name"
    t.boolean "deleted"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "log_entries", force: :cascade do |t|
    t.string "severity"
    t.string "message"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "origin"
  end

  create_table "qualification_types", force: :cascade do |t|
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "qualifications", force: :cascade do |t|
    t.string "name"
    t.string "organization"
    t.integer "qualification_type_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["qualification_type_id"], name: "index_qualifications_on_qualification_type_id"
  end

  add_foreign_key "api_users", "customers"
  add_foreign_key "customer_qualifications", "customers"
  add_foreign_key "customer_qualifications", "qualifications"
  add_foreign_key "qualifications", "qualification_types"
end

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

ActiveRecord::Schema[7.2].define(version: 2026_01_26_115948) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "delivery_points", force: :cascade do |t|
    t.bigint "delivery_route_id", null: false
    t.string "name", null: false
    t.string "address"
    t.decimal "latitude", precision: 10, scale: 7
    t.decimal "longitude", precision: 10, scale: 7
    t.integer "position", default: 0, null: false
    t.text "memo"
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["delivery_route_id", "position"], name: "index_delivery_points_on_delivery_route_id_and_position"
    t.index ["delivery_route_id"], name: "index_delivery_points_on_delivery_route_id"
    t.index ["status"], name: "index_delivery_points_on_status"
  end

  create_table "delivery_routes", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name", null: false
    t.text "description"
    t.date "date"
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["date"], name: "index_delivery_routes_on_date"
    t.index ["status"], name: "index_delivery_routes_on_status"
    t.index ["user_id"], name: "index_delivery_routes_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name", null: false
    t.boolean "guest", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "delivery_points", "delivery_routes"
  add_foreign_key "delivery_routes", "users"
end

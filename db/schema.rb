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

ActiveRecord::Schema.define(version: 2018_06_10_185432) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "balancers", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cities", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "clients", force: :cascade do |t|
    t.string "firstname", default: "", null: false
    t.string "lastname", default: "", null: false
    t.string "number", default: "", null: false
    t.integer "ucrm_id"
    t.integer "contabilium_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "corporate_cellphones", force: :cascade do |t|
    t.string "phone", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ground_wire_setup_types", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "group_permissions", force: :cascade do |t|
    t.integer "group_id"
    t.integer "permission_id"
    t.index ["group_id", "permission_id"], name: "index_group_permissions_on_group_id_and_permission_id", unique: true
  end

  create_table "groups", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false, null: false
  end

  create_table "permissions", force: :cascade do |t|
    t.string "title"
    t.string "category"
    t.string "code"
    t.boolean "view"
    t.boolean "manage"
    t.boolean "deny"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "plan_services", force: :cascade do |t|
    t.string "name", null: false
    t.integer "ucrm_plan_service_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "support_types", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "surge_protector_setup_types", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "technical_service_corporate_cellphones", force: :cascade do |t|
    t.integer "technical_service_id", null: false
    t.integer "corporate_cellphone_id", null: false
    t.index ["technical_service_id", "corporate_cellphone_id"], name: "technical_service_corporate_cellphone_unique", unique: true
  end

  create_table "technical_service_technicians", force: :cascade do |t|
    t.integer "technical_service_id", null: false
    t.integer "technician_id", null: false
    t.index ["technical_service_id", "technician_id"], name: "technical_service_technician_unique", unique: true
  end

  create_table "technical_service_work_types", force: :cascade do |t|
    t.integer "technical_service_id", null: false
    t.integer "work_type_id", null: false
    t.index ["technical_service_id", "work_type_id"], name: "technical_service_work_type_unique", unique: true
  end

  create_table "technical_services", force: :cascade do |t|
    t.integer "work_order_number", default: 0, null: false
    t.string "antenna_serial_number"
    t.string "antenna_model"
    t.inet "antenna_ip_address"
    t.string "router_model"
    t.string "router_serial_number"
    t.string "wifi_ssid"
    t.string "wifi_password"
    t.decimal "cable_length", precision: 15, scale: 2, default: "0.0", null: false
    t.integer "plug_adapter_quantity", default: 0, null: false
    t.time "arrival_time"
    t.time "departure_time"
    t.string "google_maps_url"
    t.decimal "labour_cost", precision: 15, scale: 2, default: "0.0", null: false
    t.decimal "equipment_cost", precision: 15, scale: 2, default: "0.0", null: false
    t.string "observations"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "city_id"
    t.integer "client_id"
    t.integer "tower_id"
    t.integer "transmitter_id"
    t.integer "balancer_id"
    t.integer "support_type_id"
    t.integer "plan_service_id"
    t.integer "ground_wire_setup_type_id"
    t.integer "surge_protector_setup_type_id"
    t.datetime "datetime", null: false
    t.integer "technician_id", null: false
  end

  create_table "technicians", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "towers", force: :cascade do |t|
    t.string "name", null: false
    t.integer "ucrm_site_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transmitters", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active", default: true, null: false
    t.integer "group_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "work_types", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end

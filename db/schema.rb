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

ActiveRecord::Schema.define(version: 20170215153531) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "companies", force: :cascade do |t|
    t.text     "name"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "furnizor_id"
    t.string   "region"
    t.integer  "filial_id"
    t.text     "comment"
    t.string   "shname"
    t.integer  "mpoints_count"
    t.boolean  "f"
    t.index ["filial_id"], name: "index_companies_on_filial_id", using: :btree
    t.index ["furnizor_id"], name: "index_companies_on_furnizor_id", using: :btree
  end

  create_table "filials", force: :cascade do |t|
    t.string   "name"
    t.integer  "cod_id"
    t.text     "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "furnizors", force: :cascade do |t|
    t.string   "name"
    t.string   "cod_id"
    t.text     "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lnparams", force: :cascade do |t|
    t.float    "l"
    t.float    "r"
    t.integer  "mpoint_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text     "comment"
    t.float    "ro"
    t.float    "k_scr"
    t.float    "k_tr"
    t.float    "k_peb"
    t.float    "q"
    t.float    "k_f"
    t.boolean  "f"
    t.index ["mpoint_id"], name: "index_lnparams_on_mpoint_id", using: :btree
  end

  create_table "mesubstations", force: :cascade do |t|
    t.text     "name"
    t.text     "vlclass"
    t.integer  "cod"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "meters", force: :cascade do |t|
    t.string   "metertype",      default: "ZMD",   null: false
    t.integer  "meternum",                         null: false
    t.string   "koeftt",         default: "1 / 1", null: false
    t.string   "koeftn",         default: "1 / 1", null: false
    t.integer  "mpoint_id",                        null: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.date     "relevance_date",                   null: false
    t.string   "comment"
    t.boolean  "f",              default: true,    null: false
    t.float    "koefcalc",       default: 1.0,     null: false
    t.index ["mpoint_id"], name: "index_meters_on_mpoint_id", using: :btree
  end

  create_table "mpoints", force: :cascade do |t|
    t.integer  "company_id",                                null: false
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.string   "messtation", default: "подстанция МЭ",      null: false
    t.string   "meconname",  default: "фидер МЭ",           null: false
    t.string   "clsstation", default: "подстанция клиента", null: false
    t.string   "clconname",  default: "фидер клиента",      null: false
    t.integer  "mess_id"
    t.text     "comment"
    t.string   "name",       default: "точка учета",        null: false
    t.float    "voltcl",     default: 10.0,                 null: false
    t.boolean  "f",          default: true,                 null: false
    t.index ["company_id"], name: "index_mpoints_on_company_id", using: :btree
  end

  create_table "mvalues", force: :cascade do |t|
    t.text     "comment"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "actp180",                   null: false
    t.string   "actp280",                   null: false
    t.string   "actp380",                   null: false
    t.string   "actp480",                   null: false
    t.date     "actdate",                   null: false
    t.integer  "meter_id",                  null: false
    t.boolean  "f",          default: true, null: false
    t.index ["meter_id"], name: "index_mvalues_on_meter_id", using: :btree
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.string   "resource_type"
    t.integer  "resource_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
    t.index ["name"], name: "index_roles_on_name", using: :btree
  end

  create_table "trparams", force: :cascade do |t|
    t.float    "pxx"
    t.float    "pkz"
    t.float    "snom"
    t.float    "ukz"
    t.float    "io"
    t.float    "qkz"
    t.integer  "mpoint_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text     "comment"
    t.boolean  "f"
    t.index ["mpoint_id"], name: "index_trparams_on_mpoint_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree
  end

  add_foreign_key "companies", "filials"
  add_foreign_key "companies", "furnizors"
  add_foreign_key "lnparams", "mpoints"
  add_foreign_key "meters", "mpoints"
  add_foreign_key "mpoints", "companies"
  add_foreign_key "mvalues", "meters"
  add_foreign_key "trparams", "mpoints"
end

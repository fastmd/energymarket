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

ActiveRecord::Schema.define(version: 20161124130149) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "clients", force: :cascade do |t|
    t.text     "cname"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "companies", force: :cascade do |t|
    t.text     "name"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "furnizor_id"
    t.index ["furnizor_id"], name: "index_companies_on_furnizor_id", using: :btree
  end

  create_table "furnizors", force: :cascade do |t|
    t.string   "name"
    t.string   "cod_id"
    t.text     "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lineparams", force: :cascade do |t|
    t.float    "r1"
    t.float    "r2"
    t.float    "l1"
    t.float    "l2"
    t.integer  "mpoint_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mpoint_id"], name: "index_lineparams_on_mpoint_id", using: :btree
  end

  create_table "lineprs", force: :cascade do |t|
    t.float    "l1"
    t.float    "l2"
    t.float    "p1"
    t.float    "p2"
    t.integer  "mpoint_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mpoint_id"], name: "index_lineprs_on_mpoint_id", using: :btree
  end

  create_table "mpoints", force: :cascade do |t|
    t.integer  "pnum"
    t.string   "pname"
    t.integer  "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "messtation"
    t.string   "meconname"
    t.string   "clsstation"
    t.string   "clconname"
    t.string   "voltcl"
    t.string   "metertype"
    t.integer  "meternum"
    t.string   "koeftt"
    t.string   "koeftn"
    t.integer  "koefcalc"
    t.index ["company_id"], name: "index_mpoints_on_company_id", using: :btree
  end

  create_table "mvalues", force: :cascade do |t|
    t.integer  "vnum"
    t.float    "val"
    t.text     "comment"
    t.integer  "mpoint_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date     "actdae"
    t.string   "actp180"
    t.string   "actp280"
    t.string   "actp380"
    t.string   "actp480"
    t.date     "actdate"
    t.index ["mpoint_id"], name: "index_mvalues_on_mpoint_id", using: :btree
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

  add_foreign_key "companies", "furnizors"
end

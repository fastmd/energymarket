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

ActiveRecord::Schema.define(version: 20170613140115) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "companies", force: :cascade do |t|
    t.text     "name",                         null: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "cod"
    t.text     "comment"
    t.string   "shname",                       null: false
    t.integer  "mpoints_count"
    t.boolean  "f",             default: true, null: false
  end

  create_table "filials", force: :cascade do |t|
    t.string   "name",          default: "филиал", null: false
    t.text     "comment"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "mpoints_count"
  end

  create_table "furnizors", force: :cascade do |t|
    t.string   "name",          default: "поставщик", null: false
    t.text     "comment"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "mpoints_count"
  end

  create_table "lines", force: :cascade do |t|
    t.string   "name",                                                      null: false
    t.decimal  "l",               precision: 10, scale: 4,                  null: false
    t.decimal  "r",               precision: 14, scale: 8,                  null: false
    t.decimal  "k_tr",            precision: 10, scale: 4, default: "1.03", null: false
    t.decimal  "k_f",             precision: 10, scale: 4, default: "1.15", null: false
    t.integer  "wire_id",                                                   null: false
    t.integer  "mesubstation_id",                                           null: false
    t.boolean  "f",                                        default: true,   null: false
    t.text     "comment"
    t.datetime "created_at",                                                null: false
    t.datetime "updated_at",                                                null: false
    t.index ["mesubstation_id"], name: "index_lines_on_mesubstation_id", using: :btree
    t.index ["wire_id"], name: "index_lines_on_wire_id", using: :btree
  end

  create_table "lnparams", force: :cascade do |t|
    t.integer  "mpoint_id",                 null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.text     "comment"
    t.boolean  "f",          default: true, null: false
    t.integer  "line_id",                   null: false
    t.index ["line_id"], name: "index_lnparams_on_line_id", using: :btree
    t.index ["mpoint_id"], name: "index_lnparams_on_mpoint_id", using: :btree
  end

  create_table "mesubstations", force: :cascade do |t|
    t.text     "name",                      null: false
    t.text     "vlclass"
    t.integer  "cod"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "region_id"
    t.integer  "filial_id"
    t.boolean  "f",          default: true, null: false
    t.index ["filial_id"], name: "index_mesubstations_on_filial_id", using: :btree
    t.index ["region_id"], name: "index_mesubstations_on_region_id", using: :btree
  end

  create_table "meters", force: :cascade do |t|
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
    t.integer  "thesauru_id"
    t.index ["mpoint_id"], name: "index_meters_on_mpoint_id", using: :btree
  end

  create_table "mpoints", force: :cascade do |t|
    t.integer  "company_id",                                                null: false
    t.datetime "created_at",                                                null: false
    t.datetime "updated_at",                                                null: false
    t.string   "meconname",                                                 null: false
    t.string   "clsstation",                                                null: false
    t.string   "clconname",                                                 null: false
    t.text     "comment"
    t.string   "name",                                                      null: false
    t.decimal  "voltcl",          precision: 14, scale: 4, default: "10.0", null: false
    t.boolean  "f",                                        default: true,   null: false
    t.integer  "cod"
    t.integer  "furnizor_id",                                               null: false
    t.integer  "mesubstation_id"
    t.boolean  "fct",                                      default: true,   null: false
    t.decimal  "cosfi",           precision: 3,  scale: 2
    t.boolean  "fctc"
    t.index ["company_id"], name: "index_mpoints_on_company_id", using: :btree
    t.index ["furnizor_id"], name: "index_mpoints_on_furnizor_id", using: :btree
    t.index ["mesubstation_id"], name: "index_mpoints_on_mesubstation_id", using: :btree
  end

  create_table "mvalues", force: :cascade do |t|
    t.text     "comment"
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.date     "actdate",                                            null: false
    t.integer  "meter_id",                                           null: false
    t.boolean  "f",                                   default: true, null: false
    t.decimal  "actp180",    precision: 14, scale: 4,                null: false
    t.decimal  "actp280",    precision: 14, scale: 4,                null: false
    t.decimal  "actp380",    precision: 14, scale: 4,                null: false
    t.decimal  "actp480",    precision: 14, scale: 4,                null: false
    t.boolean  "r",                                   default: true, null: false
    t.decimal  "actp580",    precision: 14, scale: 4
    t.decimal  "actp880",    precision: 14, scale: 4
    t.integer  "trab"
    t.decimal  "dwa",        precision: 20, scale: 4
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

  create_table "taus", force: :cascade do |t|
    t.integer  "tm",         null: false
    t.integer  "taum",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "thesaurus", force: :cascade do |t|
    t.string   "name",                      null: false
    t.boolean  "f",          default: true, null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "cvalue",                    null: false
    t.string   "shcvalue"
    t.string   "cod"
  end

  create_table "transformators", force: :cascade do |t|
    t.string   "name",                                               null: false
    t.decimal  "pxx",        precision: 10, scale: 4,                null: false
    t.decimal  "pkz",        precision: 10, scale: 4,                null: false
    t.decimal  "snom",       precision: 10, scale: 4,                null: false
    t.decimal  "ukz",        precision: 10, scale: 4,                null: false
    t.decimal  "i0",         precision: 10, scale: 4,                null: false
    t.decimal  "qkz",        precision: 14, scale: 8,                null: false
    t.text     "comment"
    t.boolean  "f",                                   default: true, null: false
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.string   "unom",                                               null: false
  end

  create_table "trparams", force: :cascade do |t|
    t.integer  "mpoint_id",                       null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.text     "comment"
    t.boolean  "f",                default: true, null: false
    t.integer  "transformator_id",                null: false
    t.index ["mpoint_id"], name: "index_trparams_on_mpoint_id", using: :btree
    t.index ["transformator_id"], name: "index_trparams_on_transformator_id", using: :btree
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

  create_table "wires", force: :cascade do |t|
    t.string   "name",                                               null: false
    t.decimal  "ro",         precision: 10, scale: 4,                null: false
    t.decimal  "k_scr",      precision: 10, scale: 4,                null: false
    t.decimal  "k_peb",      precision: 10, scale: 4,                null: false
    t.decimal  "q",          precision: 10, scale: 4,                null: false
    t.boolean  "f",                                   default: true, null: false
    t.text     "comment"
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
  end

  add_foreign_key "lines", "mesubstations"
  add_foreign_key "lines", "wires"
  add_foreign_key "lnparams", "lines"
  add_foreign_key "lnparams", "mpoints"
  add_foreign_key "mesubstations", "filials"
  add_foreign_key "mesubstations", "thesaurus", column: "region_id"
  add_foreign_key "meters", "mpoints"
  add_foreign_key "meters", "thesaurus"
  add_foreign_key "mpoints", "companies"
  add_foreign_key "mpoints", "furnizors"
  add_foreign_key "mpoints", "mesubstations"
  add_foreign_key "mvalues", "meters"
  add_foreign_key "trparams", "mpoints"
  add_foreign_key "trparams", "transformators"
end

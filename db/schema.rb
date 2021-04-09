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

ActiveRecord::Schema.define(version: 2021_04_02_150114) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "attendance_records", force: :cascade do |t|
    t.bigint "meeting_id"
    t.bigint "committee_enrollment_id"
    t.boolean "attended"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["committee_enrollment_id"], name: "index_attendance_records_on_committee_enrollment_id"
    t.index ["meeting_id"], name: "index_attendance_records_on_meeting_id"
  end

  create_table "committee_enrollments", force: :cascade do |t|
    t.bigint "committee_id"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["committee_id"], name: "index_committee_enrollments_on_committee_id"
    t.index ["user_id"], name: "index_committee_enrollments_on_user_id"
  end

  create_table "committees", force: :cascade do |t|
    t.text "committee_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "max_unexcused_absences", default: 6
    t.integer "max_excused_absences", default: 11
    t.integer "max_combined_absences", default: 11
  end

  create_table "committees_roles", id: false, force: :cascade do |t|
    t.bigint "committee_id", null: false
    t.bigint "role_id", null: false
    t.index ["committee_id", "role_id"], name: "index_committees_roles_on_committee_id_and_role_id", unique: true
    t.index ["committee_id"], name: "index_committees_roles_on_committee_id"
  end

  create_table "excuses", force: :cascade do |t|
    t.text "reason"
    t.bigint "attendance_record_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "status", default: 0
    t.index ["attendance_record_id"], name: "index_excuses_on_attendance_record_id"
  end

  create_table "meetings", force: :cascade do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.bigint "committee_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "title"
    t.index ["committee_id"], name: "index_meetings_on_committee_id"
  end

  create_table "roles", force: :cascade do |t|
    t.text "role_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "roles_users", id: false, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "role_id", null: false
    t.index ["user_id", "role_id"], name: "index_roles_users_on_user_id_and_role_id", unique: true
    t.index ["user_id"], name: "index_roles_users_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.text "username"
    t.text "password_digest"
    t.text "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "attendance_records", "committee_enrollments"
  add_foreign_key "attendance_records", "meetings"
  add_foreign_key "committee_enrollments", "committees"
  add_foreign_key "committee_enrollments", "users"
  add_foreign_key "excuses", "attendance_records"
  add_foreign_key "meetings", "committees"
end

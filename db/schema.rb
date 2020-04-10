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

ActiveRecord::Schema.define(version: 2020_04_09_145130) do

  create_table "archived_time_entries", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.datetime "date_of_activity"
    t.float "hours"
    t.string "activity_log"
    t.integer "task_id"
    t.integer "week_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "project_id"
    t.boolean "sick"
    t.boolean "personal_day"
    t.integer "updated_by"
    t.integer "status_id"
    t.integer "approved_by"
    t.datetime "approved_date"
    t.time "time_in"
    t.time "time_out"
    t.integer "vacation_type_id"
  end

  create_table "archived_weeks", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.integer "status_id"
    t.datetime "approved_date"
    t.integer "approved_by"
    t.text "comments"
    t.string "time_sheet"
    t.integer "proxy_user_id"
    t.datetime "proxy_updated_date"
    t.string "reset_reason"
    t.integer "week_id"
    t.integer "reset_by"
    t.datetime "reset_date"
  end

  create_table "case_studies", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "case_study_name"
    t.text "case_study_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ckeditor_assets", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "data_file_name", null: false
    t.string "data_content_type"
    t.integer "data_file_size"
    t.string "type", limit: 30
    t.integer "width"
    t.integer "height"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["type"], name: "index_ckeditor_assets_on_type"
  end

  create_table "customers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "city"
    t.string "state"
    t.string "zipcode"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.string "theme"
    t.string "logo"
    t.decimal "regular_hours", precision: 10, default: "8"
  end

  create_table "customers_holidays", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "customer_id"
    t.integer "holiday_id"
    t.index ["customer_id", "holiday_id"], name: "index_customers_holidays_on_customer_id_and_holiday_id"
    t.index ["holiday_id", "customer_id"], name: "index_customers_holidays_on_holiday_id_and_customer_id"
  end

  create_table "default_reports", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "customer_id"
    t.integer "project_id"
    t.integer "user_id"
    t.date "start_date"
    t.date "end_date"
    t.string "month"
    t.boolean "current_week"
    t.boolean "exclude_pending_user"
    t.boolean "billable"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "employment_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "customer_id"
  end

  create_table "employment_types_vacation_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "employment_type_id"
    t.integer "vacation_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "expense_records", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "expense_type"
    t.text "description"
    t.date "date"
    t.integer "amount"
    t.string "attachment"
    t.integer "project_id"
    t.bigint "week_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["week_id"], name: "index_expense_records_on_week_id"
  end

  create_table "external_configurations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "customer_id"
    t.string "system_type"
    t.string "url"
    t.string "jira_email"
    t.string "password"
    t.string "confirm_password"
    t.integer "created_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "features", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "feature_type"
    t.text "feature_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "holiday_exceptions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "user_id"
    t.integer "project_id"
    t.integer "customer_id"
    t.text "holiday_ids"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "holidays", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.boolean "global"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "date"
  end

  create_table "projects", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.bigint "customer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.integer "proxy"
    t.boolean "inactive"
    t.integer "adhoc_pm_id"
    t.datetime "adhoc_start_date"
    t.datetime "adhoc_end_date"
    t.boolean "deactivate_notifications", default: false
    t.integer "external_type_id"
    t.index ["customer_id"], name: "index_projects_on_customer_id"
  end

  create_table "projects_users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "project_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active"
    t.datetime "sepration_date"
    t.index ["project_id"], name: "index_projects_users_on_project_id"
    t.index ["user_id"], name: "index_projects_users_on_user_id"
  end

  create_table "report_logos", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "report_logo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shared_employees", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "user_id"
    t.integer "customer_id"
    t.boolean "permanent", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "statuses", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tasks", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "code"
    t.string "description"
    t.bigint "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "default_comment"
    t.boolean "active"
    t.boolean "billable", default: false
    t.integer "imported_from"
    t.index ["project_id"], name: "index_tasks_on_project_id"
  end

  create_table "time_entries", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.datetime "date_of_activity"
    t.float "hours"
    t.string "activity_log", limit: 500
    t.bigint "task_id"
    t.bigint "week_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "project_id"
    t.boolean "sick"
    t.boolean "personal_day"
    t.integer "updated_by"
    t.integer "status_id"
    t.integer "approved_by"
    t.datetime "approved_date"
    t.time "time_in"
    t.time "time_out"
    t.integer "vacation_type_id"
    t.string "partial_day"
    t.index ["task_id"], name: "index_time_entries_on_task_id"
    t.index ["user_id"], name: "index_time_entries_on_user_id"
    t.index ["week_id"], name: "index_time_entries_on_week_id"
  end

  create_table "upload_timesheets", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "week_id"
    t.string "time_sheet"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_notifications", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "user_id"
    t.string "notification_type"
    t.text "body"
    t.integer "count"
    t.boolean "seen", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "week_id"
  end

  create_table "user_recommendations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "project_id"
    t.string "recommendation"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_recommendations_on_user_id"
  end

  create_table "user_roles", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "role_id", null: false
    t.index ["user_id", "role_id"], name: "index_user_roles_on_user_id_and_role_id"
  end

  create_table "user_vacation_tables", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "user_id"
    t.integer "vacation_id"
    t.decimal "days_used", precision: 5, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_week_statuses", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "status_id"
    t.integer "week_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_week_statuses_on_user_id"
    t.index ["week_id"], name: "index_user_week_statuses_on_week_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "provider"
    t.string "uid"
    t.datetime "oauth_expires_at"
    t.string "name"
    t.string "oauth_token"
    t.boolean "pm"
    t.boolean "cm"
    t.boolean "admin"
    t.boolean "user"
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.bigint "invited_by_id"
    t.integer "invitations_count", default: 0
    t.boolean "google_account"
    t.boolean "proxy"
    t.integer "customer_id"
    t.datetime "vacation_start_date"
    t.datetime "vacation_end_date"
    t.integer "report_logo"
    t.integer "default_project"
    t.integer "default_task"
    t.integer "employment_type"
    t.datetime "invitation_start_date"
    t.boolean "shared"
    t.string "authentication_token", limit: 30
    t.boolean "is_active", default: true
    t.integer "parent_user_id"
    t.string "image"
    t.string "emergency_contact"
    t.index ["authentication_token"], name: "index_users_on_authentication_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invitations_count"], name: "index_users_on_invitations_count"
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_users_on_invited_by_type_and_invited_by_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "vacation_requests", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "customer_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "vacation_start_date"
    t.datetime "vacation_end_date"
    t.integer "sick", limit: 1
    t.integer "personal", limit: 1
    t.string "status"
    t.text "comment"
    t.integer "vacation_type_id"
    t.string "partial_day"
    t.decimal "hours_used", precision: 5, scale: 2
    t.index ["customer_id"], name: "index_vacation_requests_on_customer_id"
    t.index ["user_id"], name: "index_vacation_requests_on_user_id"
  end

  create_table "vacation_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "customer_id"
    t.string "employment_type"
    t.string "vacation_title"
    t.integer "max_days"
    t.boolean "rollover"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "paid"
    t.integer "vacation_bank"
    t.boolean "accrual"
  end

  create_table "weeks", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.integer "status_id"
    t.datetime "approved_date"
    t.integer "approved_by"
    t.text "comments"
    t.string "time_sheet"
    t.integer "proxy_user_id"
    t.datetime "proxy_updated_date"
    t.boolean "dismiss", default: false
  end

  add_foreign_key "projects", "customers"
  add_foreign_key "tasks", "projects"
  add_foreign_key "time_entries", "tasks"
  add_foreign_key "time_entries", "users"
  add_foreign_key "time_entries", "weeks"
  add_foreign_key "user_recommendations", "users"
end

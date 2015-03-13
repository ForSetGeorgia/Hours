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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20150313073336) do

  create_table "organizations", :force => true do |t|
    t.string   "long_name"
    t.string   "short_name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "organizations", ["long_name"], :name => "index_organizations_on_long_name"
  add_index "organizations", ["short_name"], :name => "index_organizations_on_short_name"

  create_table "page_translations", :force => true do |t|
    t.integer  "page_id"
    t.string   "locale",     :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "title"
    t.text     "content"
  end

  add_index "page_translations", ["locale"], :name => "index_page_translations_on_locale"
  add_index "page_translations", ["page_id"], :name => "index_page_translations_on_page_id"

  create_table "pages", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "pages", ["name"], :name => "index_pages_on_name"

  create_table "programs", :force => true do |t|
    t.string   "name"
    t.boolean  "active"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "project_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "project_types", ["name"], :name => "index_project_types_on_name"

  create_table "projects", :force => true do |t|
    t.integer  "organization_id"
    t.string   "name"
    t.boolean  "active",          :default => true
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.integer  "project_type_id"
    t.integer  "program_id"
  end

  add_index "projects", ["active"], :name => "index_projects_on_active"
  add_index "projects", ["name"], :name => "index_projects_on_name"
  add_index "projects", ["organization_id"], :name => "index_projects_on_organization_id"
  add_index "projects", ["project_type_id"], :name => "index_projects_on_project_type_id"

  create_table "stages", :force => true do |t|
    t.string   "name"
    t.integer  "sort_order", :default => 0
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "stages", ["sort_order", "name"], :name => "index_stages_on_sort_order_and_name"

  create_table "timestamps", :force => true do |t|
    t.integer  "project_id"
    t.integer  "user_id"
    t.string   "diff_level"
    t.integer  "duration"
    t.text     "notes"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "stage_id"
  end

  add_index "timestamps", ["project_id"], :name => "index_timestamps_on_project_id"
  add_index "timestamps", ["stage_id"], :name => "index_timestamps_on_stage_id"
  add_index "timestamps", ["user_id"], :name => "index_timestamps_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.integer  "role",                   :default => 0,  :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "provider"
    t.string   "uid"
    t.string   "nickname"
    t.string   "avatar"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["provider", "uid"], :name => "idx_users_provider"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end

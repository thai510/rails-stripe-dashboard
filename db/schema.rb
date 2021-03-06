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

ActiveRecord::Schema.define(:version => 20130603204223) do

  create_table "datasets", :force => true do |t|
    t.integer  "trialing"
    t.integer  "active"
    t.integer  "canceled"
    t.integer  "unpaid"
    t.integer  "past_due"
    t.integer  "active_canceled_at_period_end"
    t.integer  "trialing_canceled_at_period_end"
    t.integer  "charges_today"
    t.integer  "amount_charged_today"
    t.integer  "amount_refunded_today"
    t.integer  "refunds_today"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
    t.integer  "churn"
    t.float    "churn_rate"
    t.integer  "customer_lifetime_value"
    t.integer  "average_monthly_revenue_per_customer"
    t.integer  "average_monthly_revenue"
    t.integer  "converted"
    t.integer  "failed_to_convert"
  end

  create_table "events", :force => true do |t|
    t.string   "json"
    t.integer  "event_id"
    t.boolean  "livemode"
    t.string   "event_type"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end

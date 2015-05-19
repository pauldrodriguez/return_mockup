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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150518190138) do

  create_table "order_items", force: true do |t|
    t.integer  "order_num"
    t.text     "product_name"
    t.text     "size"
    t.integer  "quantity"
    t.decimal  "original_price"
    t.decimal  "price"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "order_id"
    t.string   "status"
    t.integer  "amount_returned", default: 0, null: false
  end

  create_table "orders", force: true do |t|
    t.integer  "order_num"
    t.decimal  "amount"
    t.string   "first_name"
    t.string   "last_name"
    t.decimal  "discounts"
    t.decimal  "tax"
    t.decimal  "subtotal"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "return_items", force: true do |t|
    t.integer  "return_order_id"
    t.integer  "order_num"
    t.integer  "order_id"
    t.string   "product_name"
    t.integer  "return_type"
    t.string   "return_reasons"
    t.decimal  "amount_refunded"
    t.string   "original_size"
    t.string   "new_size"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status"
    t.integer  "quantity"
    t.integer  "return_order_item_id"
  end

  create_table "return_order_attributes", force: true do |t|
    t.integer "return_reason_attrbiute_id"
    t.integer "return_order_id"
  end

  create_table "return_orders", force: true do |t|
    t.integer  "order_num"
    t.integer  "order_id"
    t.decimal  "amount_refunded"
    t.integer  "return_status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "return_reason_attributes", force: true do |t|
    t.integer "parent_id"
    t.string  "code_name"
    t.string  "attr_name"
    t.integer "display_order"
    t.integer "attr_type"
  end

end

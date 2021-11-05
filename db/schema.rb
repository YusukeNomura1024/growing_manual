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

ActiveRecord::Schema.define(version: 2021_09_09_164328) do

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.integer "resource_id"
    t.string "author_type"
    t.integer "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "bookmarks", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "manual_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["manual_id"], name: "index_bookmarks_on_manual_id"
    t.index ["user_id"], name: "index_bookmarks_on_user_id"
  end

  create_table "categories", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_categories_on_user_id"
  end

  create_table "manuals", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "title", null: false
    t.string "image_id"
    t.text "description"
    t.boolean "status", default: false, null: false
    t.datetime "release_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_manuals_on_user_id"
  end

  create_table "memo_links", force: :cascade do |t|
    t.integer "procedure_id", null: false
    t.integer "memo_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["memo_id"], name: "index_memo_links_on_memo_id"
    t.index ["procedure_id"], name: "index_memo_links_on_procedure_id"
  end

  create_table "memos", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "category_id"
    t.string "name", null: false
    t.text "description"
    t.text "url"
    t.text "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_memos_on_category_id"
    t.index ["user_id"], name: "index_memos_on_user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "manual_id"
    t.integer "review_id"
    t.text "comment", null: false
    t.integer "type", null: false
    t.boolean "is_replied", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["manual_id"], name: "index_messages_on_manual_id"
    t.index ["review_id"], name: "index_messages_on_review_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.integer "visitor_id"
    t.integer "visited_id", null: false
    t.integer "review_id"
    t.integer "manual_id"
    t.integer "type", null: false
    t.boolean "is_checked", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["manual_id"], name: "index_notifications_on_manual_id"
    t.index ["review_id"], name: "index_notifications_on_review_id"
    t.index ["visited_id"], name: "index_notifications_on_visited_id"
    t.index ["visitor_id"], name: "index_notifications_on_visitor_id"
  end

  create_table "procedures", force: :cascade do |t|
    t.integer "manual_id", null: false
    t.string "title", null: false
    t.integer "position", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["manual_id"], name: "index_procedures_on_manual_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "manual_id", null: false
    t.text "comment"
    t.integer "rate", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["manual_id"], name: "index_reviews_on_manual_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "tag_maps", force: :cascade do |t|
    t.integer "manual_id", null: false
    t.integer "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["manual_id"], name: "index_tag_maps_on_manual_id"
    t.index ["tag_id"], name: "index_tag_maps_on_tag_id"
  end

  create_table "tags", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_tags_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "full_name", null: false
    t.string "pen_name", null: false
    t.string "image_id"
    t.boolean "is_active", default: true, null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end

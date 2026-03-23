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

ActiveRecord::Schema[8.1].define(version: 2026_03_23_183340) do
  create_table "Accounts", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.column "account_type", "enum('client','restaurant')", null: false
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "password_hash", null: false
    t.datetime "updated_at", null: false
    t.string "username", null: false
    t.index ["email"], name: "accounts_email_unique", unique: true
    t.index ["username"], name: "accounts_username_unique", unique: true
  end

  create_table "Address", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "city", limit: 50, null: false
    t.string "country", limit: 20, null: false
    t.datetime "created_at", null: false
    t.string "postal_code", limit: 15, null: false
    t.string "street", limit: 50, null: false
    t.datetime "updated_at", null: false
    t.index ["country", "city", "street", "postal_code"], name: "address_country_city_street_postal_code_unique", unique: true
  end

  create_table "Categories", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ClientFavourites", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "client_id", null: false, unsigned: true
    t.datetime "created_at", null: false
    t.bigint "menu_item_id", null: false, unsigned: true
    t.datetime "updated_at", null: false
    t.index ["client_id", "menu_item_id"], name: "clientfavourites_client_id_menu_item_id_unique", unique: true
    t.index ["client_id"], name: "clientfavourites_client_id_index"
    t.index ["menu_item_id"], name: "clientfavourites_menu_item_id_foreign"
  end

  create_table "ClientItemInteractions", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "client_id", null: false, unsigned: true
    t.datetime "created_at", null: false
    t.column "interaction", "enum('like','dislike')", null: false
    t.bigint "menu_item_id", null: false, unsigned: true
    t.datetime "updated_at", null: false
    t.index ["client_id", "menu_item_id"], name: "clientiteminteractions_client_id_menu_item_id_unique", unique: true
    t.index ["client_id"], name: "clientiteminteractions_client_id_index"
    t.index ["menu_item_id"], name: "clientiteminteractions_menu_item_id_foreign"
  end

  create_table "ClientRecommendations", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "client_id", null: false, unsigned: true
    t.datetime "created_at", null: false
    t.bigint "menu_item_id", null: false, unsigned: true
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "clientrecommendations_client_id_index"
    t.index ["menu_item_id"], name: "clientrecommendations_menu_item_id_foreign"
  end

  create_table "Clients", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "account_id", null: false, unsigned: true
    t.bigint "address_id", unsigned: true
    t.datetime "created_at", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "phone_number"
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "clients_account_id_unique", unique: true
    t.index ["address_id"], name: "clients_address_id_foreign"
    t.index ["phone_number"], name: "clients_phone_number_unique", unique: true
  end

  create_table "DietaryTags", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
  end

  create_table "MenuItemCategories", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "category_id", null: false, unsigned: true
    t.datetime "created_at", null: false
    t.bigint "menu_item_id", null: false, unsigned: true
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "menuitemcategories_category_id_index"
    t.index ["menu_item_id", "category_id"], name: "menuitemcategories_menu_item_id_category_id_unique", unique: true
  end

  create_table "MenuItemDietaryTags", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "dietary_tag_id", null: false, unsigned: true
    t.bigint "menu_item_id", null: false, unsigned: true
    t.datetime "updated_at", null: false
    t.index ["dietary_tag_id"], name: "menuitemdietarytags_dietary_tag_id_index"
    t.index ["menu_item_id", "dietary_tag_id"], name: "menuitemdietarytags_menu_item_id_dietary_tag_id_unique", unique: true
  end

  create_table "MenuItemImages", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "image_url", null: false
    t.bigint "menu_item_id", null: false, unsigned: true
    t.datetime "updated_at", null: false
    t.index ["menu_item_id"], name: "menuitemimages_menu_item_id_foreign"
  end

  create_table "MenuItems", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "description", null: false
    t.string "name", null: false
    t.decimal "price", precision: 8, scale: 2, null: false
    t.bigint "restaurant_id", null: false, unsigned: true
    t.datetime "updated_at", null: false
    t.index ["name"], name: "menuitems_name_index"
    t.index ["restaurant_id"], name: "menuitems_restaurant_id_index"
  end

  create_table "OrderMenuItems", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "menu_item_id", null: false, unsigned: true
    t.bigint "order_id", null: false, unsigned: true
    t.decimal "price_at_order", precision: 8, scale: 2, null: false
    t.bigint "quantity", null: false
    t.datetime "updated_at", null: false
    t.index ["menu_item_id"], name: "ordermenuitems_menu_item_id_index"
    t.index ["order_id", "menu_item_id"], name: "ordermenuitems_order_id_menu_item_id_unique", unique: true
    t.index ["order_id"], name: "ordermenuitems_order_id_index"
  end

  create_table "Orders", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "address_id", null: false, unsigned: true
    t.bigint "client_id", null: false, unsigned: true
    t.datetime "created_at", null: false
    t.bigint "restaurant_id", null: false, unsigned: true
    t.column "status", "enum('pending_acceptance','preparing','prepared','in_delivery','delivered','canceled')", default: "pending_acceptance", null: false
    t.decimal "total_price", precision: 8, scale: 2, null: false
    t.datetime "updated_at", null: false
    t.index ["address_id"], name: "orders_address_id_foreign"
    t.index ["client_id"], name: "orders_client_id_foreign"
    t.index ["restaurant_id"], name: "orders_restaurant_id_foreign"
    t.index ["status"], name: "orders_status_index"
  end

  create_table "RestaurantLogoImages", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "image_url", null: false
    t.bigint "restaurant_id", null: false, unsigned: true
    t.datetime "updated_at", null: false
    t.index ["restaurant_id"], name: "restaurantlogoimages_restaurant_id_foreign"
  end

  create_table "Restaurants", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "account_id", null: false, unsigned: true
    t.bigint "address_id", null: false, unsigned: true
    t.datetime "created_at", null: false
    t.string "description"
    t.string "name", null: false
    t.string "phone_number", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "restaurants_account_id_unique", unique: true
    t.index ["address_id"], name: "restaurants_address_id_foreign"
  end

  create_table "Reviews", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "client_id", null: false, unsigned: true
    t.datetime "created_at", null: false
    t.bigint "order_id", null: false, unsigned: true
    t.integer "rating", null: false
    t.bigint "restaurant_id", null: false, unsigned: true
    t.string "text", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id", "restaurant_id", "order_id"], name: "reviews_client_id_restaurant_id_order_id_unique", unique: true
    t.index ["client_id"], name: "reviews_client_id_index"
    t.index ["order_id"], name: "reviews_order_id_foreign"
    t.index ["restaurant_id"], name: "reviews_restaurant_id_index"
  end

  add_foreign_key "ClientFavourites", "Clients", column: "client_id", name: "clientfavourites_client_id_foreign"
  add_foreign_key "ClientFavourites", "MenuItems", column: "menu_item_id", name: "clientfavourites_menu_item_id_foreign"
  add_foreign_key "ClientItemInteractions", "Clients", column: "client_id", name: "clientiteminteractions_client_id_foreign"
  add_foreign_key "ClientItemInteractions", "MenuItems", column: "menu_item_id", name: "clientiteminteractions_menu_item_id_foreign"
  add_foreign_key "ClientRecommendations", "Clients", column: "client_id", name: "clientrecommendations_client_id_foreign"
  add_foreign_key "ClientRecommendations", "MenuItems", column: "menu_item_id", name: "clientrecommendations_menu_item_id_foreign"
  add_foreign_key "Clients", "Accounts", column: "account_id", name: "clients_account_id_foreign"
  add_foreign_key "Clients", "Address", column: "address_id", name: "clients_address_id_foreign"
  add_foreign_key "MenuItemCategories", "Categories", column: "category_id", name: "menuitemcategories_category_id_foreign"
  add_foreign_key "MenuItemCategories", "MenuItems", column: "menu_item_id", name: "menuitemcategories_menu_item_id_foreign"
  add_foreign_key "MenuItemDietaryTags", "DietaryTags", column: "dietary_tag_id", name: "menuitemdietarytags_dietary_tag_id_foreign"
  add_foreign_key "MenuItemDietaryTags", "MenuItems", column: "menu_item_id", name: "menuitemdietarytags_menu_item_id_foreign"
  add_foreign_key "MenuItemImages", "MenuItems", column: "menu_item_id", name: "menuitemimages_menu_item_id_foreign"
  add_foreign_key "MenuItems", "Restaurants", column: "restaurant_id", name: "menuitems_restaurant_id_foreign"
  add_foreign_key "OrderMenuItems", "MenuItems", column: "menu_item_id", name: "ordermenuitems_menu_item_id_foreign"
  add_foreign_key "OrderMenuItems", "Orders", column: "order_id", name: "ordermenuitems_order_id_foreign"
  add_foreign_key "Orders", "Address", column: "address_id", name: "orders_address_id_foreign"
  add_foreign_key "Orders", "Clients", column: "client_id", name: "orders_client_id_foreign"
  add_foreign_key "Orders", "Restaurants", column: "restaurant_id", name: "orders_restaurant_id_foreign"
  add_foreign_key "RestaurantLogoImages", "Restaurants", column: "restaurant_id", name: "restaurantlogoimages_restaurant_id_foreign"
  add_foreign_key "Restaurants", "Accounts", column: "account_id", name: "restaurants_account_id_foreign"
  add_foreign_key "Restaurants", "Address", column: "address_id", name: "restaurants_address_id_foreign"
  add_foreign_key "Reviews", "Clients", column: "client_id", name: "reviews_client_id_foreign"
  add_foreign_key "Reviews", "Orders", column: "order_id", name: "reviews_order_id_foreign"
  add_foreign_key "Reviews", "Restaurants", column: "restaurant_id", name: "reviews_restaurant_id_foreign"
end

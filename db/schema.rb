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

ActiveRecord::Schema[7.0].define(version: 2023_08_04_185444) do
  create_table "ingredient_recipes", force: :cascade do |t|
    t.integer "ingredient_id", null: false
    t.integer "recipe_id", null: false
    t.decimal "quantity", precision: 5, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ingredient_id"], name: "index_ingredient_recipes_on_ingredient_id"
    t.index ["recipe_id"], name: "index_ingredient_recipes_on_recipe_id"
  end

  create_table "ingredients", force: :cascade do |t|
    t.string "name"
    t.string "unit"
    t.decimal "cost", precision: 5, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "inventory_item_changes", force: :cascade do |t|
    t.string "change_type", null: false
    t.integer "change_id", null: false
    t.integer "inventory_item_id"
    t.decimal "quantity", precision: 5, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["change_type", "change_id"], name: "index_inventory_item_changes_on_change"
    t.index ["inventory_item_id"], name: "index_inventory_item_changes_on_inventory_item_id"
  end

  create_table "inventory_items", force: :cascade do |t|
    t.integer "location_id", null: false
    t.integer "ingredient_id", null: false
    t.decimal "quantity", precision: 5, scale: 2, default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ingredient_id"], name: "index_inventory_items_on_ingredient_id"
    t.index ["location_id"], name: "index_inventory_items_on_location_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "locations_staffs", id: false, force: :cascade do |t|
    t.integer "staff_id", null: false
    t.integer "location_id", null: false
    t.index ["location_id", "staff_id"], name: "index_locations_staffs_on_location_id_and_staff_id"
    t.index ["staff_id", "location_id"], name: "index_locations_staffs_on_staff_id_and_location_id"
  end

  create_table "menus", force: :cascade do |t|
    t.integer "location_id", null: false
    t.integer "recipe_id", null: false
    t.decimal "price", precision: 5, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["location_id"], name: "index_menus_on_location_id"
    t.index ["recipe_id"], name: "index_menus_on_recipe_id"
  end

  create_table "recipes", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sales", force: :cascade do |t|
    t.integer "location_id", null: false
    t.integer "staff_id", null: false
    t.integer "menu_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["location_id"], name: "index_sales_on_location_id"
    t.index ["menu_id"], name: "index_sales_on_menu_id"
    t.index ["staff_id"], name: "index_sales_on_staff_id"
  end

  create_table "staffs", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stock_changes", force: :cascade do |t|
    t.integer "location_id", null: false
    t.integer "staff_id", null: false
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["location_id"], name: "index_stock_changes_on_location_id"
    t.index ["staff_id"], name: "index_stock_changes_on_staff_id"
  end

  add_foreign_key "ingredient_recipes", "ingredients"
  add_foreign_key "ingredient_recipes", "recipes"
  add_foreign_key "inventory_items", "ingredients"
  add_foreign_key "inventory_items", "locations"
  add_foreign_key "menus", "locations"
  add_foreign_key "menus", "recipes"
  add_foreign_key "sales", "locations"
  add_foreign_key "sales", "menus"
  add_foreign_key "sales", "staffs"
  add_foreign_key "stock_changes", "locations"
  add_foreign_key "stock_changes", "staffs"
end

# frozen_string_literal: true

class CreateMenus < ActiveRecord::Migration[7.0]
  def change
    create_table :menus do |t|
      t.references :location, null: false, foreign_key: true
      t.references :recipe, null: false, foreign_key: true
      t.decimal :price, precision: 5, scale: 2

      t.timestamps
    end
  end
end

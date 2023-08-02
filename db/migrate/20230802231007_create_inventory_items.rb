# frozen_string_literal: true

class CreateInventoryItems < ActiveRecord::Migration[7.0]
  def change
    create_table :inventory_items do |t|
      t.references :location, null: false, foreign_key: true
      t.references :ingredient, null: false, foreign_key: true
      t.decimal :quantity, precision: 5, scale: 2, default: 0.0

      t.timestamps
    end
  end
end

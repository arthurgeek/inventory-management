# frozen_string_literal: true

class CreateInventoryItemChanges < ActiveRecord::Migration[7.0]
  def change
    create_table :inventory_item_changes do |t|
      t.references :change, polymorphic: true, null: false
      t.references :inventory_item
      t.decimal :quantity, precision: 5, scale: 2

      t.timestamps
    end
  end
end

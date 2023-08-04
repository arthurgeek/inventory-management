# frozen_string_literal: true

class CreateStockChanges < ActiveRecord::Migration[7.0]
  def change
    create_table :stock_changes do |t|
      t.references :location, null: false, foreign_key: true
      t.references :staff, null: false, foreign_key: true
      t.string :type

      t.timestamps
    end
  end
end

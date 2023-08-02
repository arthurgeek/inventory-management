# frozen_string_literal: true

class CreateIngredients < ActiveRecord::Migration[7.0]
  def change
    create_table :ingredients do |t|
      t.string :name
      t.string :unit
      t.decimal :cost, precision: 5, scale: 2

      t.timestamps
    end
  end
end

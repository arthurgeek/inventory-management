# frozen_string_literal: true

class CreateIngredientRecipes < ActiveRecord::Migration[7.0]
  def change
    create_table :ingredient_recipes do |t|
      t.references :ingredient, null: false, foreign_key: true
      t.references :recipe, null: false, foreign_key: true
      t.decimal :quantity, precision: 5, scale: 2

      t.timestamps
    end
  end
end

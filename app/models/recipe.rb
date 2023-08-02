# frozen_string_literal: true

class Recipe < ApplicationRecord
  has_many :menus # rubocop:todo Rails/HasManyOrHasOneDependent
  has_many :ingredient_recipes # rubocop:todo Rails/HasManyOrHasOneDependent
  has_many :ingredients, through: :ingredient_recipes

  def total_cost
    ingredient_recipes.sum do |ir|
      ir.ingredient.cost * ir.quantity
    end.round(2)
  end
end

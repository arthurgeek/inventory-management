# frozen_string_literal: true

require 'test_helper'

class RecipeTest < ActiveSupport::TestCase
  test 'calculates the total cost of its ingredients' do
    recipe = Recipe.create(name: 'Test Recipe')

    ingredient1 = Ingredient.create(name: 'Ingredient 1', unit: 'kg', cost: 5.32)
    ingredient2 = Ingredient.create(name: 'Ingredient 2', unit: 'kg', cost: 8.74)

    IngredientRecipe.create(recipe:, ingredient: ingredient1, quantity: 2.28)
    IngredientRecipe.create(recipe:, ingredient: ingredient2, quantity: 1.26)

    assert_equal 23.14, recipe.total_cost
  end
end

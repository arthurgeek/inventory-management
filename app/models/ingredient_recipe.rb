# frozen_string_literal: true

class IngredientRecipe < ApplicationRecord
  belongs_to :ingredient
  belongs_to :recipe
end

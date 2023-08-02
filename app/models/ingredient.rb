# frozen_string_literal: true

class Ingredient < ApplicationRecord
  has_many :ingredient_recipes # rubocop:todo Rails/HasManyOrHasOneDependent
  has_many :recipes, through: :ingredient_recipes
end

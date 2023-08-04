# frozen_string_literal: true

class IngredientWithQuantity
  attr_reader :ingredient, :quantity

  def initialize(ingredient:, quantity:)
    @ingredient = ingredient
    @quantity = quantity
  end
end

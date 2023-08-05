# frozen_string_literal: true

module Services
  class SaleHandler
    def initialize(menu:, staff:)
      @menu = menu
      @staff = staff
    end

    def sell
      ActiveRecord::Base.transaction do
        Sale.create(menu: @menu, location: @menu.location, staff: @staff).tap do |sale|
          @menu.recipe.ingredient_recipes.each { |ingredient_recipe| handle_ingredient_recipe(sale, ingredient_recipe) }
        end
      end
    end

    private

    def handle_ingredient_recipe(sale, ingredient_recipe)
      inventory_item = InventoryItem.find_by(location: @menu.location, ingredient: ingredient_recipe.ingredient)

      raise InsufficientStock if inventory_item.nil? || (inventory_item.quantity - ingredient_recipe.quantity).negative?

      inventory_item.update(quantity: inventory_item.quantity - ingredient_recipe.quantity)

      InventoryItemChange.create(
        change: sale,
        inventory_item: inventory_item,
        quantity: -ingredient_recipe.quantity
      )
    end
  end
end

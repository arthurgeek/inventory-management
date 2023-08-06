# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe Reports::SalesRevenue do
  let(:staff) { Staff.create(name: 'John Doe') }
  let(:location) { Location.create(name: 'Super Salad', staffs: [staff]) }
  let(:another_location) { Location.create(name: 'Mega Salad', staffs: [staff]) }
  let(:tomato) { Ingredient.create(name: 'Tomatoes', unit: 'kilos', cost: 1.62) }
  let(:lettuce) { Ingredient.create(name: 'Lettuce', unit: 'kilos', cost: 2.38) }
  let(:garlic) { Ingredient.create(name: 'Garlic', unit: 'kilos', cost: 3.45) }
  let(:egg) { Ingredient.create(name: 'Egg', unit: 'piece', cost: 0.23) }

  let!(:inventory) do
    [location, another_location].each do |location|
      InventoryItem.create(location: location, ingredient: lettuce, quantity: 100)
      InventoryItem.create(location: location, ingredient: tomato, quantity: 100)
      InventoryItem.create(location: location, ingredient: egg, quantity: 100)
      InventoryItem.create(location: location, ingredient: garlic, quantity: 100)
    end
  end

  let(:tomato_soup) do
    Recipe.create(
      name: 'Tomato Soup',
      ingredient_recipes: [
        IngredientRecipe.create(ingredient: tomato, quantity: 0.2),
        IngredientRecipe.create(ingredient: garlic, quantity: 0.01)
      ]
    )
  end
  let(:egg_salad) do
    Recipe.create(
      name: 'Egg Salad',
      ingredient_recipes: [
        IngredientRecipe.create(ingredient: egg, quantity: 2.0),
        IngredientRecipe.create(ingredient: lettuce, quantity: 0.2)
      ]
    )
  end

  let(:tomato_soup_menu) { Menu.create(location: location, recipe: tomato_soup, price: 10.50) }
  let(:tomato_soup_menu_at_another_location) do
    Menu.create(location: another_location, recipe: tomato_soup, price: 11.00)
  end
  let(:egg_salad_menu) { Menu.create(location: location, recipe: egg_salad, price: 5.30) }

  let!(:sales_for_tomato_soup) do
    5.times.collect do
      Services::SaleHandler.new(menu: tomato_soup_menu, staff: staff).sell
    end
  end
  let!(:sales_for_egg_salad) do
    3.times.collect do
      Services::SaleHandler.new(menu: egg_salad_menu, staff: staff).sell
    end
  end
  let!(:sales_for_another_location) do
    2.times.collect do
      Services::SaleHandler.new(menu: tomato_soup_menu_at_another_location, staff: staff).sell
    end
  end

  let(:total_revenue_for_tomato_soup) do
    sales_for_tomato_soup.sum { |sale| sale.menu.price }
  end

  let(:total_revenue_for_egg_salad) do
    sales_for_egg_salad.sum { |sale| sale.menu.price }
  end

  context 'a sales revenue report' do
    it 'returns the total revenue from all sales for the given location' do
      expect(
        Reports::SalesRevenue.new(location: location).value
      ).to eq(total_revenue_for_tomato_soup + total_revenue_for_egg_salad)
    end

    it 'return its report name' do
      expect(Reports::SalesRevenue.new(location: location).name).to eq('Total revenue from all sales')
    end
  end
end
# rubocop:enable Metrics/BlockLength

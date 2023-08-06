# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe Reports::WasteCost do
  let(:staff) { Staff.create(name: 'John Doe') }
  let(:location) { Location.create(name: 'Super Salad', staffs: [staff]) }
  let(:another_location) { Location.create(name: 'Mega Salad', staffs: [staff]) }
  let(:tomato) { Ingredient.create(name: 'Tomatoes', unit: 'kilos', cost: 1.62) }
  let(:lettuce) { Ingredient.create(name: 'Lettuce', unit: 'kilos', cost: 2.38) }

  let!(:inventory) do
    [location, another_location].each do |location|
      InventoryItem.create(location: location, ingredient: lettuce, quantity: 100)
      InventoryItem.create(location: location, ingredient: tomato, quantity: 100)
    end
  end

  let(:first_waste_ingredients) do
    [
      IngredientWithQuantity.new(ingredient: tomato, quantity: 90),
      IngredientWithQuantity.new(ingredient: lettuce, quantity: 95)
    ]
  end

  let(:second_waste_ingredients) do
    [
      IngredientWithQuantity.new(ingredient: tomato, quantity: 70),
      IngredientWithQuantity.new(ingredient: lettuce, quantity: 80)
    ]
  end

  let!(:first_waste) do
    Services::WasteHandler.new(
      waste_items: first_waste_ingredients,
      location: location, staff: staff
    ).record
  end

  let!(:second_waste) do
    Services::WasteHandler.new(
      waste_items: second_waste_ingredients,
      location: location, staff: staff
    ).record
  end

  let!(:waste_for_another_location) do
    Services::WasteHandler.new(
      waste_items: [IngredientWithQuantity.new(ingredient: lettuce, quantity: 70)],
      location: another_location, staff: staff
    ).record
  end

  let(:total_first_waste_cost) do
    first_waste.inventory_item_changes.sum do |change|
      change.inventory_item.ingredient.cost * change.quantity
    end
  end

  let(:total_second_waste_cost) do
    second_waste.inventory_item_changes.sum do |change|
      change.inventory_item.ingredient.cost * change.quantity
    end
  end

  context 'a waste cost report' do
    it 'returns the total cost of all wasted ingredients for the given location' do
      expect(
        Reports::WasteCost.new(location: location).value
      ).to eq(total_first_waste_cost + total_second_waste_cost)
    end

    it 'return its report name' do
      expect(Reports::WasteCost.new(location: location).name).to eq('Cost of all recorded waste')
    end
  end
end
# rubocop:enable Metrics/BlockLength

# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe Reports::InventoryValue do
  let(:staff) { Staff.create(name: 'John Doe') }
  let(:location) { Location.create(name: 'Super Salad', staffs: [staff]) }
  let(:another_location) { Location.create(name: 'Mega Salad', staffs: [staff]) }

  let(:tomato) { Ingredient.create(name: 'Tomatoes', unit: 'kilos', cost: 1.62) }
  let(:lettuce) { Ingredient.create(name: 'Lettuce', unit: 'kilos', cost: 2.38) }

  let!(:inventory) do
    [
      InventoryItem.create(location: location, ingredient: tomato, quantity: 10),
      InventoryItem.create(location: location, ingredient: lettuce, quantity: 5)
    ]
  end

  let!(:inventory_at_another_location) do
    [
      InventoryItem.create(location: another_location, ingredient: tomato, quantity: 100),
      InventoryItem.create(location: another_location, ingredient: lettuce, quantity: 100)
    ]
  end

  context 'an inventory value report' do
    it 'returns the total value of all ingredients in the inventory for the given location' do
      expect(
        Reports::InventoryValue.new(location: location).value
      ).to eq(inventory.sum { |item| item.ingredient.cost * item.quantity })
    end

    it 'return its report name' do
      expect(Reports::InventoryValue.new(location: location).name).to eq('Total value of current inventory')
    end
  end
end
# rubocop:enable Metrics/BlockLength

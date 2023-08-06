# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe Reports::DeliveryCost do
  let(:staff) { Staff.create(name: 'John Doe') }
  let(:location) { Location.create(name: 'Super Salad', staffs: [staff]) }
  let(:another_location) { Location.create(name: 'Mega Salad', staffs: [staff]) }

  let(:tomato) { Ingredient.create(name: 'Tomatoes', unit: 'kilos', cost: 1.62) }
  let(:lettuce) { Ingredient.create(name: 'Lettuce', unit: 'kilos', cost: 2.38) }
  let(:garlic) { Ingredient.create(name: 'Garlic', unit: 'kilos', cost: 3.45) }
  let(:egg) { Ingredient.create(name: 'Egg', unit: 'piece', cost: 0.23) }

  let(:first_delivery_ingredients) do
    [
      IngredientWithQuantity.new(ingredient: tomato, quantity: 10),
      IngredientWithQuantity.new(ingredient: egg, quantity: 50)
    ]
  end

  let(:second_delivery_ingredients) do
    [
      IngredientWithQuantity.new(ingredient: egg, quantity: 50),
      IngredientWithQuantity.new(ingredient: lettuce, quantity: 10)
    ]
  end

  let!(:first_delivery) do
    Services::DeliveryHandler.new(
      delivery_items: first_delivery_ingredients,
      location: location,
      staff: staff
    ).accept
  end

  let!(:second_delivery) do
    Services::DeliveryHandler.new(
      delivery_items: second_delivery_ingredients,
      location: location,
      staff: staff
    ).accept
  end

  let!(:delivery_for_another_location) do
    Services::DeliveryHandler.new(
      delivery_items: first_delivery_ingredients,
      location: another_location,
      staff: staff
    ).accept
  end

  let(:total_first_delivery_cost) do
    first_delivery_ingredients.sum do |item|
      item.ingredient.cost * item.quantity
    end
  end

  let(:total_second_delivery_cost) do
    second_delivery_ingredients.sum do |item|
      item.ingredient.cost * item.quantity
    end
  end

  context 'a delivery cost report' do
    it 'returns the sum of the cost of all ingredients part of all deliveries for the given location' do
      expect(
        Reports::DeliveryCost.new(location: location).value
      ).to eq(total_first_delivery_cost + total_second_delivery_cost)
    end

    it 'return its report name' do
      expect(Reports::DeliveryCost.new(location: location).name).to eq('Total cost of all deliveries')
    end
  end
end
# rubocop:enable Metrics/BlockLength

# frozen_string_literal: true

RSpec.configure do |rspec|
  # This config option will be enabled by default on RSpec 4,
  # but for reasons of backwards compatibility, you have to
  # set it on RSpec 3.
  #
  # It causes the host group and examples to inherit metadata
  # from the shared context.
  rspec.shared_context_metadata_behavior = :apply_to_host_groups
end

RSpec.shared_context 'delivery and waste shared context', shared_context: :metadata do
  let(:staff) { Staff.create(name: 'John Doe') }
  let(:location) { Location.create(name: 'Super Salad', staffs: [staff]) }
  let(:tomato) { Ingredient.create(name: 'Tomatoes', unit: 'kilos', cost: 1.6) }
  let(:lettuce) { Ingredient.create(name: 'Lettuce', unit: 'kilos', cost: 2.3) }
  let(:ingredients_with_quantities) do
    [
      IngredientWithQuantity.new(ingredient: tomato, quantity: 3.0),
      IngredientWithQuantity.new(ingredient: lettuce, quantity: 2.0)
    ]
  end

  let(:delivery_handler) do
    Services::DeliveryHandler.new(delivery_items: ingredients_with_quantities, location: location, staff: staff)
  end
  let(:waste_handler) do
    Services::WasteHandler.new(
      waste_items: ingredients_with_quantities,
      location: location,
      staff: staff
    )
  end
end

RSpec.shared_context 'delivery context', shared_context: :metadata do
  include_context 'delivery and waste shared context'

  let(:delivery_items) { ingredients_with_quantities }
end

RSpec.shared_context 'waste context', shared_context: :metadata do
  include_context 'delivery and waste shared context'

  let(:waste_items) { ingredients_with_quantities }
  let!(:inventory_items) do
    [
      InventoryItem.create(ingredient: tomato, location: location, quantity: 10.0),
      InventoryItem.create(ingredient: lettuce, location: location, quantity: 10.0)
    ]
  end
end

RSpec.configure do |rspec|
  rspec.include_context 'delivery and waste shared context', include_shared: true
  rspec.include_context 'delivery context', include_shared: true
  rspec.include_context 'waste context', include_shared: true
end

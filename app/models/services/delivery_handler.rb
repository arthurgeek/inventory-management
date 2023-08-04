# frozen_string_literal: true

module Services
  class DeliveryHandler
    def initialize(delivery_items:, location:, staff:)
      @delivery_items = delivery_items
      @location = location
      @staff = staff
    end

    def accept
      Delivery.create(location: @location, staff: @staff).tap do |delivery|
        @delivery_items.each do |item|
          inventory_item = find_or_create_inventory_item(item.ingredient)

          InventoryItemChange.create(change: delivery, inventory_item: inventory_item, quantity: item.quantity)

          inventory_item.quantity += item.quantity
          inventory_item.save
        end
      end
    end

    private

    def find_or_create_inventory_item(ingredient)
      InventoryItem.find_or_create_by(location: @location, ingredient: ingredient)
    end
  end
end

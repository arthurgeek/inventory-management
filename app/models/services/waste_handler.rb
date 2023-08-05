# frozen_string_literal: true

module Services
  class WasteHandler
    def initialize(waste_items:, location:, staff:)
      @waste_items = waste_items
      @location = location
      @staff = staff
    end

    def record
      Waste.create(location: @location, staff: @staff).tap do |waste|
        @waste_items.each do |item|
          inventory_item = InventoryItem.find_by(location: @location, ingredient: item.ingredient)

          InventoryItemChange.create(change: waste,
                                     inventory_item: inventory_item,
                                     quantity: inventory_item.quantity - item.quantity)

          inventory_item.quantity = item.quantity
          inventory_item.save
        end
      end
    end
  end
end

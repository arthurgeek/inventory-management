# frozen_string_literal: true

module Reports
  class DeliveryCost < Base
    def initialize(location:)
      super(location)
    end

    def name
      'Total cost of all deliveries'
    end

    def value
      @location.deliveries.joins(
        inventory_item_changes: { inventory_item: :ingredient }
      ).sum('inventory_item_changes.quantity * ingredients.cost')
    end
  end
end

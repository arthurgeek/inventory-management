# frozen_string_literal: true

module Reports
  class WasteCost < Base
    def initialize(location:)
      super(location)
    end

    def name
      'Cost of all recorded waste'
    end

    def value
      @location.wastes.joins(
        inventory_item_changes: { inventory_item: :ingredient }
      ).sum('inventory_item_changes.quantity * ingredients.cost')
    end
  end
end

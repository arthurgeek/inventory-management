# frozen_string_literal: true

require 'rails_helper'
require 'shared/contexts/delivery_and_waste'

# rubocop:disable Metrics/BlockLength
RSpec.describe Services::WasteHandler do
  include_context 'waste context'

  describe 'recording waste' do
    let(:waste_handler) do
      Services::WasteHandler.new(
        waste_items: ingredients_with_quantities,
        location: location,
        staff: staff
      )
    end

    it 'creates a new waste in the database' do
      expect { waste_handler.record }.to change { Waste.count }.by(1)
    end

    it 'returns the newly created waste' do
      expect(waste_handler.record).to be_a(Waste)
    end

    context 'the returned waste' do
      subject(:waste) { waste_handler.record }

      it 'is associated with given location' do
        expect(waste.location).to eq(location)
      end

      it 'is associated with given staff' do
        expect(waste.staff).to eq(staff)
      end

      context 'the associated inventory item changes' do
        subject(:inventory_item_changes) { waste.inventory_item_changes }

        it 'are associated with the newly created waste' do
          expect(inventory_item_changes).not_to be_empty
        end

        it 'are created for each waste item' do
          expect { waste_handler.record }.to change { InventoryItemChange.count }.by(waste_items.count)
        end

        it 'have change set as the newly created waste' do
          expect(inventory_item_changes).to all(have_attributes(change: waste))
        end

        it 'have quantity change set as the difference betweem given quantity and the original item quantity' do
          original_quantities = inventory_items.index_by(&:ingredient).transform_values(&:quantity)
          new_quantities = waste_items.index_by(&:ingredient).transform_values(&:quantity)

          wasted_amounts = original_quantities.keys.map do |ingredient|
            original_quantities[ingredient] - new_quantities[ingredient]
          end

          expect(inventory_item_changes.map(&:quantity)).to match_array(wasted_amounts)
        end

        it 'have ingredient set as given ingredients' do
          expect(inventory_item_changes.map(&:inventory_item).map(&:ingredient)).to match_array(
            waste_items.map(&:ingredient)
          )
        end
      end

      context 'the associated inventory items' do
        it "have the ingredient's inventory quantity set to given quantity" do
          waste_handler.record

          expect(inventory_items.map(&:reload).map(&:quantity)).to match_array(waste_items.map(&:quantity))
        end
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength

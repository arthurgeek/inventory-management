# frozen_string_literal: true

require 'rails_helper'
require 'shared/contexts/delivery_and_waste'

# rubocop:disable Metrics/BlockLength
RSpec.describe Services::DeliveryHandler do
  include_context 'delivery context'

  describe 'accepting a delivery' do
    it 'creates a new delivery in the database' do
      expect { delivery_handler.accept }.to change { Delivery.count }.by(1)
    end

    it 'returns the newly created delivery' do
      expect(delivery_handler.accept).to be_a(Delivery)
    end

    context 'the returned delivery' do
      subject(:delivery) { delivery_handler.accept }

      it 'is associated with given location' do
        expect(delivery.location).to eq(location)
      end

      it 'is associated with given staff' do
        expect(delivery.staff).to eq(staff)
      end

      context 'the associated inventory item changes' do
        subject(:inventory_item_changes) { delivery.inventory_item_changes }

        it 'are associated with the newly created delivery' do
          expect(inventory_item_changes).not_to be_empty
        end

        it 'are created for each delivery item' do
          expect { delivery_handler.accept }.to change { InventoryItemChange.count }.by(delivery_items.count)
        end

        it 'have change set as the newly created delivery' do
          expect(inventory_item_changes).to all(have_attributes(change: delivery))
        end

        it 'have quantity change set as given quantity' do
          expect(inventory_item_changes.map(&:quantity)).to match_array(delivery_items.map(&:quantity))
        end

        it 'have ingredient set as given ingredients' do
          expect(inventory_item_changes.map(&:inventory_item).map(&:ingredient)).to match_array(
            delivery_items.map(&:ingredient)
          )
        end
      end

      context 'the associated inventory items' do
        let(:delivery_item) { delivery_items.first }

        context 'when a given ingredient is already part of the location inventory' do
          let(:old_quantity) { 5.0 }
          let!(:existing_inventory_item) do
            InventoryItem.create(
              ingredient: delivery_item.ingredient,
              location: location,
              quantity: old_quantity
            )
          end

          it 'does not create a new inventory item' do
            expect { delivery }.to change { InventoryItem.count }.by(delivery_items.count - 1)
          end

          it "increases the ingredient's inventory by given quantity" do
            delivery
            expect(existing_inventory_item.reload.quantity).to eq(old_quantity + delivery_item.quantity)
          end
        end

        context 'when a given ingredient is not part of the location inventory' do
          it 'creates a new inventory item' do
            expect { delivery }.to change { InventoryItem.count }.by(delivery_items.count)
          end

          it "sets the inventory item's quantity to the delivered quantity" do
            delivery

            new_inventory_item = InventoryItem.find_by(ingredient: delivery_item.ingredient, location: location)
            expect(new_inventory_item.quantity).to eq(delivery_item.quantity)
          end
        end
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength

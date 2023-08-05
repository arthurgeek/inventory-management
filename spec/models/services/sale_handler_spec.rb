# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength

RSpec.shared_examples 'a sale for a recipe without enough stock' do
  it 'raises insufficient stock error' do
    expect { sale_handler.sell }.to raise_error(InsufficientStock)
  end

  it 'does not create a sale' do
    expect do
      sale_handler.sell
    rescue InsufficientStock # rubocop:disable Lint/SuppressedException
    end.to_not(change { Sale.count })
  end

  it 'does not create any inventory item changes' do
    expect do
      sale_handler.sell
    rescue InsufficientStock # rubocop:disable Lint/SuppressedException
    end.to_not(change { InventoryItemChange.count })
  end

  it "does not change any quantities for given recipe's ingredients" do
    expect do
      sale_handler.sell
    rescue InsufficientStock # rubocop:disable Lint/SuppressedException
    end.to_not(change { inventory_items.map(&:reload).map(&:quantity) })
  end
end

RSpec.describe Services::SaleHandler do
  let(:location) { Location.create(name: 'Super Salad') }
  let(:staff) { Staff.create(name: 'John Doe', locations: [location]) }
  let(:lettuce) { Ingredient.create(name: 'Romaine Lettuce', unit: 'kilos', cost: 1.32) }
  let(:carrot) { Ingredient.create(name: 'Carrot', unit: 'kilos', cost: 1.57) }
  let(:lettuce_quantity) { 0.3 }
  let(:carrot_quantity) { 0.4 }
  let(:recipe) do
    Recipe.create(
      name: 'Romaine Calm and Carrot On',
      ingredient_recipes: [
        IngredientRecipe.create(ingredient: lettuce, quantity: lettuce_quantity),
        IngredientRecipe.create(ingredient: carrot, quantity: carrot_quantity)
      ]
    )
  end
  let(:menu) { Menu.create(location: location, recipe: recipe) }

  subject(:sale_handler) do
    Services::SaleHandler.new(menu: menu, staff: staff)
  end

  describe 'selling a menu' do
    context 'when there are enough ingredients in stock' do
      let!(:inventory_items) do
        [
          InventoryItem.create(location: location, ingredient: lettuce, quantity: lettuce_quantity + 0.1),
          InventoryItem.create(location: location, ingredient: carrot, quantity: carrot_quantity + 0.1)
        ]
      end

      it 'creates a new sale in the database' do
        expect { sale_handler.sell }.to change { Sale.count }.by(1)
      end

      it 'returns the newly created sale' do
        expect(sale_handler.sell).to be_a(Sale)
      end

      context 'the returned sale' do
        subject(:sale) { sale_handler.sell }

        it 'is associated with given menu' do
          expect(sale.menu).to eq(menu)
        end

        it 'is associated with given staff' do
          expect(sale.staff).to eq(staff)
        end

        it "is associated with the menu's location" do
          expect(sale.location).to eq(menu.location)
        end

        context 'the associated inventory item changes' do
          subject(:inventory_item_changes) { sale.inventory_item_changes }

          it 'are associated with the newly created sale' do
            expect(inventory_item_changes).not_to be_empty
          end

          it "are created for each recipe's ingredient" do
            expect { sale_handler.sell }.to change { InventoryItemChange.count }.by(recipe.ingredients.count)
          end

          it 'have change set as the newly created sale' do
            expect(inventory_item_changes).to all(have_attributes(change: sale))
          end

          it "have quantity change set as the negative of the given recipe ingredient's quantity" do
            expect(inventory_item_changes.map(&:quantity)).to match_array(recipe.ingredient_recipes.map do |ir|
                                                                            -ir.quantity
                                                                          end)
          end

          it "have ingredient set as given recipe's ingredients" do
            expect(inventory_item_changes.map(&:inventory_item).map(&:ingredient)).to match_array(
              recipe.ingredients
            )
          end
        end

        context 'the associated inventory items' do
          it "decreases the given recipe's ingredients inventory by recipe's quantity" do
            original_quantities = inventory_items.map(&:quantity)
            recipe_quantities = recipe.ingredient_recipes.map(&:quantity)

            sale

            new_quantities = inventory_items.map(&:reload).map(&:quantity)

            expect(new_quantities).to eq(
              original_quantities.zip(recipe_quantities).map do |x, y|
                x - y
              end
            )
          end
        end
      end
    end

    context 'when there are not enough ingredients in stock for at least one ingredient' do
      let!(:inventory_items) do
        [
          InventoryItem.create(location: location, ingredient: lettuce, quantity: lettuce_quantity),
          InventoryItem.create(location: location, ingredient: carrot, quantity: carrot_quantity - 0.1)
        ]
      end

      it_behaves_like 'a sale for a recipe without enough stock'
    end

    context 'when at least one ingredient does not exist' do
      let!(:inventory_items) do
        []
      end

      it_behaves_like 'a sale for a recipe without enough stock'
    end
  end
end

# rubocop:enable Metrics/BlockLength

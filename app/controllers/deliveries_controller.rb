# frozen_string_literal: true

class DeliveriesController < ApplicationController
  before_action :authenticate_user!
  before_action :parse_json, only: :create

  def new
    @ingredients = Ingredient.select(:id, :name, :unit).all.to_json
  end

  def create
    ingredients_with_quantities = @json.map do |i|
      IngredientWithQuantity.new(ingredient: Ingredient.find(i[:id]), quantity: i[:quantity])
    end

    Services::DeliveryHandler.new(
      delivery_items: ingredients_with_quantities,
      location: current_location,
      staff: current_user
    ).accept

    # TODO: Validation

    head :ok
  end

  private

  def parse_json
    @json = JSON.parse(request.raw_post, symbolize_names: true)
  end
end

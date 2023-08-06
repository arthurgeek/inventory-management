# frozen_string_literal: true

require 'faker'

puts '🌱 Seeding database' # rubocop:disable Rails/Output

def random_date
  rand(0..37).days.ago
end

def random_timestamps
  date = random_date
  { created_at: date, updated_at: date }
end

puts '📍 Seeding default location and staff' # rubocop:disable Rails/Output

default_location = Location.create({ name: Rails.configuration.x.location.name }.merge(random_timestamps))

10.times do
  default_location.staffs.create({ name: Faker::Name.unique.name }.merge(random_timestamps))
end

puts '🏡 Seeding other locations and staff' # rubocop:disable Rails/Output

20.times do
  location = Location.create({ name: Faker::Restaurant.unique.name }.merge(random_timestamps))

  10.times do
    location.staffs.create({ name: Faker::Name.unique.name }.merge(random_timestamps))
  end
end

puts '👷‍♀️ Adding existing staff to some other locations' # rubocop:disable Rails/Output

Staff.order('RANDOM()').limit(50).each do |staff|
  Timecop.freeze(staff.created_at)

  staff.locations << Location.where.not(
    locations: { id: staff.locations.pluck(:id) }
  ).order('RANDOM()').limit(rand(1..3))

  Timecop.return
end

puts '🌽 Seeding ingredients' # rubocop:disable Rails/Output

200.times do
  Ingredient.create({
    name: Faker::Food.unique.ingredient,
    unit: Faker::Food.metric_measurement,
    cost: Faker::Number.between(from: 0.02, to: 4.00)
  }.merge(random_timestamps))
end

puts '🥗 Seeding recipes and menus' # rubocop:disable Rails/Output

100.times do
  recipe = Recipe.create({
    name: Faker::Music::RockBand.unique.name
  }.merge(random_timestamps))

  Ingredient.order('RANDOM()').limit(rand(2..7)).each do |ingredient|
    IngredientRecipe.create({
      recipe: recipe,
      ingredient: ingredient,
      quantity: Faker::Number.between(from: 0.0, to: 10.0)
    }.merge(random_timestamps))
  end

  Location.order('RANDOM()').limit(rand(2..10)).each do |location|
    Menu.create({
      location: location,
      recipe: recipe,
      price: recipe.total_cost * rand(1.1..1.3) # apply a random markup to cost
    }.merge(random_timestamps))
  end
end

puts '🗄️ Seeding inventory items' # rubocop:disable Rails/Output

Location.all.each do |location|
  Ingredient.all.each do |ingredient|
    InventoryItem.create({
      location: location,
      ingredient: ingredient,
      quantity: rand(50..200)
    }.merge(random_timestamps))
  end
end

puts '🚚 Seeding deliveries' # rubocop:disable Rails/Output

50.times do
  ingredient_with_quantities = Ingredient.order('RANDOM()').limit(rand(5..10)).map do |i|
    IngredientWithQuantity.new(ingredient: i, quantity: rand(5..10))
  end

  location = Location.order('RANDOM()').first

  Timecop.freeze(random_date)

  Services::DeliveryHandler.new(
    delivery_items: ingredient_with_quantities,
    location: location,
    staff: location.staffs.order('RANDOM()').first
  ).accept

  Timecop.return
end

puts '🛒 Seeding sales' # rubocop:disable Rails/Output
600.times do
  menu = Menu.order('RANDOM()').first

  Timecop.freeze(random_date)

  Services::SaleHandler.new(
    menu: menu,
    staff: menu.location.staffs.order('RANDOM()').first
  ).sell

  Timecop.return
rescue InsufficientStock
  puts '⏭️ Skipping sale for item with insufficient stock' # rubocop:disable Rails/Output
end

puts '🗑️ Seeding waste' # rubocop:disable Rails/Output
100.times do
  ingredient_with_quantities = Ingredient.order('RANDOM()').limit(rand(1..5)).map do |i|
    # quantity here is the new reconciled quantity not the wasted quantity.
    # we'll calculate the waste automatically. here, I'm recording between 5 and 15% waste
    original_quantity = i.inventory_item.quantity
    new_quantity = original_quantity - (original_quantity * rand(0.05..0.15))
    IngredientWithQuantity.new(ingredient: i, quantity: new_quantity)
  end

  location = Location.order('RANDOM()').first

  Timecop.freeze(random_date)

  Services::WasteHandler.new(
    waste_items: ingredient_with_quantities,
    location: location,
    staff: location.staffs.order('RANDOM()').first
  ).record

  Timecop.return
end

puts '✅ Database seeded' # rubocop:disable Rails/Output

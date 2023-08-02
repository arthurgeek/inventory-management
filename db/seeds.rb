# frozen_string_literal: true

require 'faker'

puts '🌱 Seeding database' # rubocop:disable Rails/Output

20.times do
  location = Location.create({ name: Faker::Restaurant.unique.name })

  10.times do
    location.staffs.create({ name: Faker::Name.unique.name })
  end
end

# Now, select some random Staff and add to other random locations
Staff.order('RANDOM()').limit(50).each do |staff|
  staff.locations << Location.where.not(
    locations: { id: staff.locations.pluck(:id) }
  ).order('RANDOM()').limit(rand(1..3))
end

200.times do
  Ingredient.create({
                      name: Faker::Food.unique.ingredient,
                      unit: Faker::Food.metric_measurement,
                      cost: Faker::Number.between(from: 0.02, to: 4.00)
                    })
end

100.times do
  recipe = Recipe.create({
                           name: Faker::Music::RockBand.unique.name
                         })

  Ingredient.order('RANDOM()').limit(rand(2..7)).each do |ingredient|
    IngredientRecipe.create({
                              recipe:,
                              ingredient:,
                              quantity: Faker::Number.between(from: 0.0, to: 10.0)
                            })
  end

  Location.order('RANDOM()').limit(rand(2..5)).each do |_location|
    Menu.create({
                  location: Location.order('RANDOM()').first,
                  recipe:,
                  price: recipe.total_cost * rand(1.1..1.3) # apply a random markup to cost
                })
  end
end

puts '✅ Database seeded' # rubocop:disable Rails/Output

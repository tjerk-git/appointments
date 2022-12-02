# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# Owner

# Calendar

# Spots for that calendar in this week

# The fixed test url so i can visit that calendar

# owner = Owner.create(uuid: "10", name:"Test", user_id: "10")

# calendar = Calendar.create(
#     name: "test",
#     url: owner.user_id + "/" + "test".parameterize(separator: '-'),
#     client_id: "1",
#     owner: owner
# )

3.times { 
    Spot.create(calendar: Calendar.find(1), start_date: Time.now - 1.day , end_date: Time.now - 1.day)
}

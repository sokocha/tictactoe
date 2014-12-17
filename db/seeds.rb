# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.delete_all
Match.delete_all

# User.create!([
#   {name: 'Sadiq', email: 'sokocfha@gmail.com', password: 'password'},
#   {name: 'Andres', email: 'andsres@gmail.com', password: 'password'},
#   {name: 'Rabea', email: 'rabeaa@gmail.com', password: 'password'},
#   {name: 'Julia', email: 'julida@gmail.com', password: 'password'},
#   ])

Match.create!(player_x_id: User.first.id, player_o_id: User.first(2).last.id)




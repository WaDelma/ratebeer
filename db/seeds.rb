# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
b1 = Brewery.create name:"Koff", year:1897
b2 = Brewery.create name:"Malmgard", year:2001
b3 = Brewery.create name:"Weihenstephaner", year:1040

s1 = Style.create name:"Lager"
s2 = Style.create name:"Pale Ale"
s3 = Style.create name:"Porter"
s4 = Style.create name:"Weizen"


bb1 = b1.beers.create name:"Iso 3", style: s1
bb2 = b1.beers.create name:"Karhu", style: s1
bb3 = b1.beers.create name:"Tuplahumala", style: s1
bb4 = b2.beers.create name:"Huvila Pale Ale", style: s2
bb5 = b2.beers.create name:"X Porter", style: s3
b3.beers.create name:"Hefeweizen", style: s4
b3.beers.create name:"Helles", style: s1

u = User.create username:"matti", password:"Secr3t"
u.ratings.create score: 1, beer: bb1
u.ratings.create score: 2, beer: bb2
u.ratings.create score: 3, beer: bb3
u.ratings.create score: 4, beer: bb4
u.ratings.create score: 5, beer: bb5
require 'rails_helper'

include Helpers

describe "Rating" do
  let!(:brewery) { FactoryBot.create :brewery, name:"Koff" }
  let!(:beer1) { FactoryBot.create :beer, name:"iso 3", brewery:brewery }
  let!(:beer2) { FactoryBot.create :beer, name:"Karhu", brewery:brewery }
  let!(:user) { FactoryBot.create :user }

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select('iso 3', from:'rating[beer_id]')
    fill_in('rating[score]', with:'15')

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end

  it "amount is shown on ratings page" do
    scores = [3, 5, 7, 11, 17]
    scores.each do |score|
      FactoryBot.create :rating, score: score, user: user, beer: beer1
    end
    
    visit ratings_path

    expect(page).to have_content "Number of ratings: #{scores.count}"
    scores.each do |score|
      expect(page).to have_content "#{score} #{beer1}"
    end
  end

  it "is removed from system when user does so" do
    scores = [3, 5, 7, 11, 17]
    scores.each do |score|
      FactoryBot.create :rating, score: score, user: user, beer: beer1
    end
    visit user_path(user)

    expect{
      find('form[action="/ratings/3"]').find('input[type="submit"]').click
    }.to change{Rating.count}.by(-1)

    scores.delete(7)
    scores.each do |score|
      expect(page).to have_content "#{beer1}: #{score}"
    end
    expect(page).not_to have_content "#{beer1}: 7"
  end
end
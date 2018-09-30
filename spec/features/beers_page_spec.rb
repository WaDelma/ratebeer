require 'rails_helper'

describe "Beers page" do
  before :each do
    @breweries = ["Koff", "Karjala", "Schlenkerla"]
    year = 1896
    @breweries.each do |brewery_name|
      FactoryBot.create(:brewery, name: brewery_name, year: year += 1)
    end

    visit breweries_path
  end

  it "allows creating new beer with valid name adding it to the system" do
    visit beers_path
    
    click_link "New Beer"

    fill_in('beer_name', with:'Generic')

    expect{
      click_button('Create Beer')
    }.to change{Beer.count}.by(1)
  end

  it "doesn't allow creating new beer with invalid name" do
    visit beers_path
    
    click_link "New Beer"

    expect{
      click_button('Create Beer')
    }.not_to change{Beer.count}
    expect(page).to have_content 'Name can\'t be blank'
  end
end
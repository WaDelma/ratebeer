require 'rails_helper'

RSpec.describe User, type: :model do
  it "has the username set correctly" do
    user = User.new username:"Pekka"

    expect(user.username).to eq("Pekka")
  end

  it "is not saved without a password" do
    user = User.create username:"Pekka"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "is not saved with a short password" do
    user = User.create username:"Pekka", password:"short"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "is not saved with an alphabetical password" do
    user = User.create username:"Pekka", password:"ABCDabcd"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  describe "with a proper password" do
    let(:user){ FactoryBot.create(:user) }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do
      FactoryBot.create(:rating, score: 10, user: user)
      FactoryBot.create(:rating, score: 20, user: user)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end

  describe "favorite beer" do
    let(:user){ FactoryBot.create(:user) }
  
    it "has method for determining one" do
      expect(user).to respond_to(:favorite_beer)
    end
  
    it "without ratings does not have one" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = create_beer_with_rating({user: user}, 20)
    
      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do
      create_beers_with_many_ratings({user: user}, 10, 15, 9)
      best = create_beer_with_rating({user: user}, 25 )
    
      expect(user.favorite_beer).to eq(best)
    end
  end

  describe "favorite style" do
    let(:user){ FactoryBot.create(:user) }
    let(:ipa){ FactoryBot.create(:style, name: "IPA") }
    let(:lager){ FactoryBot.create(:style, name: "Lager")  }
    let(:porter){ FactoryBot.create(:style, name: "Porter")  }
  
    it "has method for determining one" do
      expect(user).to respond_to(:favorite_style)
    end
  
    it "without ratings does not have one" do
      expect(user.favorite_style).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = create_beer_with_rating({user: user}, 20)
      expect(user.favorite_style).to eq(beer.style)
    end

    it "is the most rated of multiple styles" do
      create_beer_with_rating({user: user, style: ipa}, 1)
      beer = create_beer_with_rating({user: user, style: lager}, 4)
      create_beer_with_rating({user: user, style: porter}, 2)
      expect(user.favorite_style).to eq(beer.style)
    end

    it "has the largest average rating" do
      beer = create_beer_with_rating({user: user, style: lager}, 26)
      create_beers_with_many_ratings({user: user, style: porter}, 50, 1)
      expect(user.favorite_style).to eq(beer.style)
    end

    it "has the largest average rating which near the average of different style" do
      create_beers_with_many_ratings({user: user, style: porter}, 2, 1, 1, 1, 1)
      create_beers_with_many_ratings({user: user, style: lager}, 1, 1, 1, 1)
      beer = create_beer_with_rating({user: user, style: lager}, 3)
      expect(user.favorite_style).to eq(beer.style)
    end
  end

  describe "favorite brewery" do
    let(:user){ FactoryBot.create(:user) }
  
    it "has method for determining one" do
      expect(user).to respond_to(:favorite_brewery)
    end
  
    it "without ratings does not have one" do
      expect(user.favorite_brewery).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = create_beer_with_rating({user: user}, 20)
      expect(user.favorite_brewery).to eq(beer.brewery)
    end

    it "is the most rated of multiple breweries" do
      create_beer_with_rating({user: user, brewery: FactoryBot.create(:brewery)}, 1)
      brewery = FactoryBot.create(:brewery);
      create_beer_with_rating({user: user, brewery: brewery}, 4)
      create_beer_with_rating({user: user, brewery: FactoryBot.create(:brewery)}, 2)
      expect(user.favorite_brewery).to eq(brewery)
    end

    it "has the largest average rating" do
      brewery = FactoryBot.create(:brewery);
      create_beer_with_rating({user: user, brewery: brewery}, 26)
      create_beers_with_many_ratings({user: user, brewery: FactoryBot.create(:brewery)}, 50, 1)
      expect(user.favorite_brewery).to eq(brewery)
    end

    it "has the largest average rating which near the average of different breweries" do
      create_beers_with_many_ratings({user: user, brewery: FactoryBot.create(:brewery)}, 2, 1, 1, 1, 1)
      brewery = FactoryBot.create(:brewery)
      create_beers_with_many_ratings({user: user, brewery: brewery}, 1, 1, 1, 1)
      beer = create_beer_with_rating({user: user, brewery: brewery}, 3)
      expect(user.favorite_brewery).to eq(brewery)
    end
  end
end
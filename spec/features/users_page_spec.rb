require 'rails_helper'

describe "User" do
  let!(:user) { FactoryBot.create :user }

  describe "who has signed up" do
    it "can signin with right credentials" do
      sign_in(username:"Pekka", password:"Foobar1")

      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end

    it "is redirected back to signin form if wrong credentials given" do
      sign_in(username:"Pekka", password:"wrong")
      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'Username and/or password mismatch'
    end

    describe "with ratings" do
      let!(:brewery) { FactoryBot.create :brewery, name:"Koff" }
      let!(:beer1) { FactoryBot.create :beer, name:"iso 3", brewery:brewery }
      before :each do
        @scores = [3, 5, 7, 11, 13]
        @scores.each do |score|
          FactoryBot.create :rating, score: score, user: user, beer: beer1
        end
      end

      it "is shown their rantings on their page" do
        visit user_path(user)

        @scores.each do |score|
          expect(page).to have_content beer1.to_s + ": " + score.to_s
        end
      end

      it "is't shown others rantings on their page" do
        other = FactoryBot.create :user, username: "other"
        other_scores = [17, 19, 23, 29]
        other_scores.each do |score|
          FactoryBot.create :rating, score: score, user: other, beer: beer1
        end

        visit user_path(user)

        other_scores.each do |score|
          expect(page).not_to have_content beer1.to_s + ": " + score.to_s
        end
      end

      it "is shown their favorite style of beer and brewery on their page" do
        visit user_path(user)

        expect(page).to have_content "The favorite style of beer is Lager and favorite brewery is Koff"
      end
    end

    # 
  end

  it "when signed up with good credentials, is added to the system" do
    visit signup_path
    fill_in('user[username]', with:'Brian')
    fill_in('user[password]', with:'Secret55')
    fill_in('user[password_confirmation]', with:'Secret55')
  
    expect{
      click_button('Create User')
    }.to change{User.count}.by(1)
  end
end




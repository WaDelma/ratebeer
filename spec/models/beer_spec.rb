require 'rails_helper'

RSpec.describe Beer, type: :model do

  describe "with a brewery" do
    let(:test_brewery) { FactoryBot.create(:brewery) }

    it "and with both name and style is saved" do
      beer = Beer.create name: "Generic", style: "IPA", brewery: test_brewery

      expect(beer).to be_valid
      expect(Beer.count).to eq(1)
    end

    it "and name, but without style isn't saved" do
      beer = Beer.create name: "Generic", brewery: test_brewery
      expect(beer).not_to be_valid
      expect(Beer.count).to eq(0)
    end

    it "and style, but without name isn't saved" do
      beer = Beer.create style: "IPA", brewery: test_brewery
      expect(beer).not_to be_valid
      expect(Beer.count).to eq(0)
    end
  end
end

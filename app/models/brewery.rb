class Brewery < ApplicationRecord
  include RatingAverage
  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers
  validates :name, presence: true
  validate do || if year > Time.now.year then 
      errors.add(:year, "can't be in the future")
    end
  end

end

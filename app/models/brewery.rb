class Brewery < ApplicationRecord
  include RatingAverage
  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers
  validates :name, presence: true
  validates :year, numericality: { greater_than_or_equal_to: 1040 }
  validate do || if year > Time.now.year then 
      errors.add(:year, "can't be in the future")
    end
  end

end

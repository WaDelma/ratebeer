class User < ApplicationRecord
  include RatingAverage
  validates :username, uniqueness: true,
                       length: { in: 3..30 }
  validates :password, format: { with: /([[:digit:]].*[[:upper:]])|([[:upper:]].*[[:digit:]])/,
                                 message: "has to have atleast one digit and uppercase letter" },
                       length: { minimum: 4 },
                       unless: :oauth
  validates :oauth, inclusion: { in: [true] },
                    unless: :password
  has_secure_password
  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships

  def potential_beer_clubs
    beer_clubs.where "memberships.confirmed": [false, nil]
  end

  def actual_beer_clubs
    beer_clubs.where "memberships.confirmed": true
  end

  def to_s
    username
  end

  def favorite_beer
    return nil if ratings.empty?

    ratings.order(score: :desc).limit(1).first.beer
  end

  def self.most_rated(nth)
    all.joins(:ratings)
       .group(:id)
       .order(Arel.sql('count(ratings.score) DESC'))
       .take(nth)
  end

  def favorite_style
    favorite(:style)
  end

  def favorite_brewery
    favorite(:brewery)
  end

  private

  def favorite(fav)
    return nil if ratings.empty?

    ratings
      .group_by{ |b| b.beer.public_send(fav) }
      .transform_values! { |r| r.sum(&:score).to_f / r.length }
      .max_by(&:last)
      .first
  end
end

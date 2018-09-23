class User < ApplicationRecord
    include RatingAverage
    validates :username, uniqueness: true,
                         length: { in: 3..30 }
    validates :password, format: { with: /([[:digit:]].*[[:upper:]])|([[:upper:]].*[[:digit:]])/,
                                   message: "has to have atleast one digit and uppercase letter" },
                         length: { minimum: 4 }
    has_secure_password
    has_many :ratings, dependent: :destroy
    has_many :beers, through: :ratings
    has_many :memberships, dependent: :destroy
    has_many :beer_clubs, through: :memberships
end

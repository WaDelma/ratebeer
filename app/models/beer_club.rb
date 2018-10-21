class BeerClub < ApplicationRecord
  has_many :memberships, dependent: :destroy
  has_many :members, -> { where "memberships.confirmed": true }, through: :memberships, source: :user
  # has_many :candidates, -> { where "memberships.confirmed": [nil, false] }, through: :memberships, source: :user

  def candidates
    memberships.where "memberships.confirmed": [nil, false]
  end

  def to_s
    "#{name}, #{city}"
  end
end

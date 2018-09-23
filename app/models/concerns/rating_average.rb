module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
    if ratings.empty?
      0
    else
      ratings.map(&:score).sum.to_f / ratings.length
    end
  end
end

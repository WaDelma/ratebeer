module RatingAverage
  extend ActiveSupport::Concern

  def self.included(obj)
    obj.extend(ClassMethods)
  end

  module ClassMethods
    def top(nth)
      all.map.sort_by{ |b| -b.average_rating || 0 }.take(nth)
    end
  end

  def average_rating
    if ratings.empty?
      0
    else
      ratings.map(&:score).sum.to_f / ratings.length
    end
  end
end

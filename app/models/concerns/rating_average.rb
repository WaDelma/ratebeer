module RatingAverage
    extend ActiveSupport::Concern

    def average_rating                                                      
        return self.ratings.map {|r| r.score}.sum.to_f / self.ratings.length
    end
end

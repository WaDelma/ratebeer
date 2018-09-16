class Rating < ApplicationRecord
    belongs_to :beer
    def to_s()
        "#{self.beer}: #{self.score}"
    end
end

class Movie < ActiveRecord::Base
    def self.all_ratings
        Movie.pluck(:rating).uniq
    end
    def self.with_ratings(ratings)
        Movie.where(rating: ratings)
    end
end

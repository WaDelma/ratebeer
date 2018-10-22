class RatingsJob
  include SuckerPunch::Job

  def perform
    Rails.cache.write("beer top 3", Beer.top(3))
    Rails.cache.write("brewery top 3", Brewery.top(3))
    Rails.cache.write("style top 3", Style.top(3))
    Rails.cache.write("user most rated 5", User.most_rated(5))
    Rails.cache.write("rating count", Rating.count)
    Rails.cache.write("rating recent", Rating.includes(:beer).recent)
  end
end

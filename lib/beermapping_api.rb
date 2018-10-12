# api_key = "a73af3e0c7c009bdde78a3aa29ac3910"
class BeermappingApi
  def self.places_in(city)
    return [] if city.empty?

    city = city.downcase
    Rails.cache.fetch(city, expires_in: 1.week) { get_places_in(city) }
  end

  def self.place(place)
    return [] if place.empty?

    Rails.cache.fetch(place, expires_in: 1.week) { get_place(place) }
  end

  def self.get_places_in(city)
    raise "BEERMAPPING_APIKEY env variable not defined" if ENV['BEERMAPPING_APIKEY'].nil?

    api_key = ENV['BEERMAPPING_APIKEY']
    url = "http://beermapping.com/webservice/loccity/#{api_key}/"

    response = HTTParty.get "#{url}#{ERB::Util.url_encode city}"
    places = response.parsed_response["bmp_locations"]["location"]
    return [] if places.is_a?(Hash) && places['id'].nil?

    places = [places] if places.is_a?(Hash)
    places.map { |p| Place.new p }
  end

  def self.get_place(place)
    raise "BEERMAPPING_APIKEY env variable not defined" if ENV['BEERMAPPING_APIKEY'].nil?

    api_key = ENV['BEERMAPPING_APIKEY']
    url = "http://beermapping.com/webservice/locquery/#{api_key}/"

    response = HTTParty.get "#{url}#{place}"
    place = response.parsed_response["bmp_locations"]["location"]
    return nil if place['status'].nil?

    Place.new place
  end
end

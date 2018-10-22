class BeermappingApi
  def self.places_in(city)
    return [] if city.empty?

    city = city.downcase
    Rails.cache.fetch(city, expires_in: 1.week) { get_places_in(city) }
  end

  def self.place(place)
    return nil if place.empty?

    Rails.cache.fetch(place, expires_in: 1.week) { get_place(place) }
  end

  def self.get_places_in(city)
    raise "BEERMAPPING_APIKEY env variable not defined" if ENV['BEERMAPPING_APIKEY'].nil?

    url = "http://beermapping.com/webservice/loccity/#{ENV['BEERMAPPING_APIKEY']}/"

    begin
      places = do_api_request("#{url}#{ERB::Util.url_encode city}")
    rescue StandardError
      return []
    end

    return [] if places.is_a?(Hash) && places['id'].nil?

    places = [places] if places.is_a?(Hash)
    places.map { |p| Place.new p }
  end

  def self.get_place(place)
    raise "BEERMAPPING_APIKEY env variable not defined" if ENV['BEERMAPPING_APIKEY'].nil?

    url = "http://beermapping.com/webservice/locquery/#{ENV['BEERMAPPING_APIKEY']}/"

    begin
      place = do_api_request("#{url}#{place}")
    rescue StandardError
      return nil
    end

    return nil if place['status'].nil?

    Place.new place
  end

  def self.do_api_request(url)
    response = HTTParty.get url, format: :plain
    response = cleanup_api_stupidness(response)
    response = Hash.from_xml(response)
    response["bmp_locations"]["location"]
  end

  def self.cleanup_api_stupidness(response)
    response.gsub(/&(?!#?[a-z0-9]+;)/, '&amp;')
  end
end

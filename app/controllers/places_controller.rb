class PlacesController < ApplicationController
  def index
  end

  def show
    @place = BeermappingApi.get_place params[:id]
    return if @place.nil? || !@place.url

    @place.url = URI.decode_www_form(@place.url)[0][0]
    return if URI.parse(@place.url).scheme

    @place.url = "https://#{@place.url}"
  end

  def search
    @places = BeermappingApi.places_in(params[:city])
    if @places.nil? || @places.empty?
      redirect_to places_path, notice: "No locations in #{params[:city]}"
    else
      render :index
    end
  end
end

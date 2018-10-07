class PlacesController < ApplicationController
  def index
  end

  def show
    @place = BeermappingApi.get_place params[:id]
    if @place.url
      @place.url = URI.unescape @place.url
      if !URI.parse(@place.url).scheme
        @place.url = "https://#{@place.url}"
      end
    end
  end

  def search
    @places = BeermappingApi.places_in(params[:city])
    if @places.empty?
      redirect_to places_path, notice: "No locations in #{params[:city]}"
    else
      render :index
    end
  end
end
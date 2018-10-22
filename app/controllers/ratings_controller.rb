class RatingsController < ApplicationController
  def index
    # Sped up counting of the ratings by doing them asyncronously only every 3 minutes
    # and by optimising all of the queries
    try_update_cache
    @beers = Rails.cache.read "beer top 3"
    @breweries = Rails.cache.read "brewery top 3"
    @styles = Rails.cache.read "style top 3"
    @users = Rails.cache.read "user most rated 5"
    @ratings = Rails.cache.read "rating count"
    @recent = Rails.cache.read "rating recent"
  end

  def new
    @beers = Beer.all
    @rating = Rating.new
  end

  def create
    @rating = Rating.new params.require(:rating).permit(:score, :beer_id)
    @rating.user = current_user
    if current_user.nil?
      redirect_to signin_path, notice: 'you should be signed in'
    elsif @rating.save
      redirect_to current_user
    else
      @beers = Beer.all
      render :new
    end
  end

  def destroy
    @rating = Rating.find(params[:id])
    @rating.delete if current_user == @rating.user
    redirect_to user_path(current_user)
  end

  private

  def try_update_cache
    @semaphore ||= Mutex.new
    @semaphore.synchronize do
      unless Rails.cache.read "ratings computed"
        if Rails.cache.read("beer top 3").nil?
          RatingsJob.new.perform
        else
          RatingsJob.perform_async
        end
        Rails.cache.write("ratings computed", true, expires_in: 3.minutes)
      end
    end
  end
end

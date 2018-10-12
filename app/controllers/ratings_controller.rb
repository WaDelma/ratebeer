class RatingsController < ApplicationController
  def index
    @ratings = Rating.count
    @beers = Beer.top 3
    @breweries = Brewery.top 3
    @styles = Style.top 3
    @users = User.most_rated 5
    @recent = Rating.recent
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
end

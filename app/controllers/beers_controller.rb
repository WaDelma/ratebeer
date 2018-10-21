class BeersController < ApplicationController
  before_action :ensure_that_signed_in, except: [:index, :show]
  before_action :ensure_admin_priviledges, only: [:destroy]
  before_action :set_beer, only: [:show, :edit, :update, :destroy]
  before_action :set_data

  # GET /beers
  # GET /beers.json
  def index
    @order = params[:order] || 'name'
    return if request.format.html? && fragment_exist?("beerlist-#{@order}")

    @beers = case @order
      when 'name' then Beer.includes(:brewery, :style).order("lower(name)")
      when 'brewery' then Beer.includes(:brewery, :style).joins(:brewery).order("lower(breweries.name)")
      when 'style' then Beer.includes(:brewery, :style).joins(:style).order("lower(styles.name)")
      else Beer.includes(:brewery, :style).all
    end
  end

  # GET /beers/1
  # GET /beers/1.json
  def show
    @rating = Rating.new
    @rating.beer = @beer
  end

  # GET /beers/new
  def new
    @beer = Beer.new
  end

  # GET /beers/1/edit
  def edit
  end

  # POST /beers
  # POST /beers.json
  def create
    @beer = Beer.new(beer_params)

    respond_to do |format|
      if @beer.save
        expire_beerlist
        format.html { redirect_to beers_path, notice: 'Beer was successfully created.' }
        format.json { render :show, status: :created, location: @beer }
      else
        format.html { render :new }
        format.json { render json: @beer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /beers/1
  # PATCH/PUT /beers/1.json
  def update
    respond_to do |format|
      if @beer.update(beer_params)
        expire_beerlist
        format.html { redirect_to @beer, notice: 'Beer was successfully updated.' }
        format.json { render :show, status: :ok, location: @beer }
      else
        format.html { render :edit }
        format.json { render json: @beer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /beers/1
  # DELETE /beers/1.json
  def destroy
    @beer.destroy
    expire_beerlist
    respond_to do |format|
      format.html { redirect_to beers_url, notice: 'Beer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def expire_beerlist
    ["beerlist-name", "beerlist-brewery", "beerlist-style"].each{ |f| expire_fragment(f) }
  end

  def set_data
    @breweries = Brewery.all
    @styles = Style.all
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_beer
    @beer = Beer.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def beer_params
    params.require(:beer).permit(:name, :style_id, :brewery_id)
  end
end

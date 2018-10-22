class StylesController < ApplicationController
  before_action :set_style, only: [:show, :edit, :update, :destroy]
  before_action :ensure_that_signed_in, except: [:index, :show]
  before_action :ensure_admin_priviledges, only: [:destroy]
  def index
    @styles = Style.all
  end

  def show
  end

  def new
    @style = Style.new
  end

  def edit
  end

  def create
    @style = Style.new(style_params)
    if @style.save
      redirect_to @style, notice: 'Style was successfully created.'
    else
      render :new
    end
  end

  def update
    if @style.update(style_params)
      redirect_to @style, notice: 'Style was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @style.destroy
    redirect_to styles_url, notice: 'Style was successfully destroyed.'
  end

  private

  def set_style
    @style = Style.find(params[:id])
  end

  def style_params
    params.require(:style).permit(:description, :name)
  end
end

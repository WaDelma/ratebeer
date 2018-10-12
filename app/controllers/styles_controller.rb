class StylesController < ApplicationController
  before_action :ensure_admin_priviledges, only: [:destroy]
  def index
    @styles = Style.all
  end
end

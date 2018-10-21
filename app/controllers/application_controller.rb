class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user
  helper_method :admin?

  def current_user
    return nil if session[:user_id].nil?

    User.find(session[:user_id])
  end

  def admin?
    return false if current_user.nil?

    current_user.admin
  end

  def member(club)
    return nil if current_user.nil?

    current_user.memberships.where(beer_club_id: club).limit(1).first
  end

  def ensure_that_signed_in
    redirect_to signin_path, notice: 'you should be signed in' if current_user.nil?
  end

  def ensure_admin_priviledges
    redirect_to signin_path, notice: 'only admin can do the action' if !admin?
  end
end

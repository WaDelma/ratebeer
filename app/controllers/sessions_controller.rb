class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by username: params[:username]
    if user.authenticate(params[:password])
      return redirect_to signin_path, notice: "The account has been suspended. Please contact administrator for further information." if !user.active

      session[:user_id] = user.id
      redirect_to user, notice: "Welcome back!"
    else
      redirect_to signin_path, notice: "Username and/or password mismatch"
    end
  end

  def create_oauth
    auth = request.env['omniauth.auth']
    user = User.find_by username: auth["info"]["nickname"], oauth: auth["uid"]
    if user.nil?
      p = SecureRandom.hex(10)
      user = User.create username: auth["info"]["nickname"], oauth: auth["uid"], password: p, password_confirmation: p
      if user.id.nil?
        return redirect_to signin_path, notice: "Oauth authentication failed"
      end
    end
    session[:user_id] = user.id
    redirect_to user, notice: "Welcome back!"
  end

  def destroy
    session[:user_id] = nil

    redirect_to :root, notice: "Signed out!"
  end
end

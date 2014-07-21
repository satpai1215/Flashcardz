class SessionsController < ApplicationController

  def new
  end

  def create
  	user = User.find_by(email: params[:email].downcase)
  	if user && user.authenticate(params[:password])
  		sign_in user
  		flash[:success] = "Sign In Successful"
  		redirect_to root_path 
  	else
  		flash[:danger] = 'Invalid email/password combination'
  		redirect_to signin_path
  	end
  end

  def destroy
    sign_out
    flash[:success] = "Signed out successfully"
    redirect_to root_url
  end
end

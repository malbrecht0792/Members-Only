class SessionsController < ApplicationController
  def new
  end

  def create
  	user = User.find_by(email: params[:session][:email].downcase)
  	if user && user.authenticate(params[:session][:password])
  		#log in user
  		log_in user
  		redirect_to root_url
  	else
  		#don't log in user
  		flash.now[:danger] = 'Invalid email/password combination'
  		render 'new'
  	end
  end

  def destroy
  		log_out @current_user	
  		redirect_to root_url
  end

end

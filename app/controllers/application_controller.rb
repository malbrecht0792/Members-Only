class ApplicationController < ActionController::Base
	protect_from_forgery with: :exception

	helper_method :logged_in?

	# Logs in the given user.
	def log_in(user)
		session[:user_id] = user.id
		cookies.permanent[:remember_token] = User.new_token
	end

	# Returns the current logged-in user (if any).
	def current_user
		if session[:user_id]
			@current_user ||= User.find_by(id: session[:user_id])
		elsif cookies.signed[:user_id]
			user = User.find_by(id: cookies.signed[:user_id])
			if user && user.authenticated?(cookies[:remember_token])
				log_in user
				@current_user = user
			end
		end
	end

	def current_user=(user)
	    @current_user = user
	end

	def log_out(user)
		cookies.delete(:user_id)
    	cookies.delete(:remember_token)
    	session.delete(:user_id)
    	@current_user = nil
	end

	# Returns true if the user is logged in, false otherwise.
	def logged_in?
		!current_user.nil?
	end

end

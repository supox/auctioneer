class SessionsController < ApplicationController
  def new
  end

  def create
	  begin
		  user = User.find_by_email(params[:session][:email])
		  if user && user.authenticate(params[:session][:password])
		    sign_in user
		    redirect_back_or user
		    return
		  end
    rescue
    end
    
    flash.now[:error] = t :invalid_email_password_combination
    render 'new'
  end

  def destroy
    sign_out
    redirect_to root_path
  end
end


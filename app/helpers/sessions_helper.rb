module SessionsHelper

  def sign_in(user)
    current_user = user
    cookies.permanent[:remember_token] = user.remember_token
  end
  
  def sign_out
    cookies.delete(:remember_token)
		@current_user= nil
  end

  def signed_in?
    !current_user.nil?
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= User.find_by_remember_token(cookies[:remember_token])
  end

  def current_user?(user)
    user == current_user
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.fullpath
  end

  def admin_user
    redirect_to(root_path) unless signed_in? && current_user.admin?
  end

  def signed_in_user
  	signed = signed_in?
    unless signed
      store_location
      redirect_to signin_path, notice: "Please sign in."
    end
		signed
  end
end

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  
  protect_from_forgery with: :exception
  before_filter :configure_devise_params, if: :devise_controller?
  def configure_devise_params
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:name, :remote_user_image_url, :email, :password, :password_confirmation)
    end
  end

  def after_sign_up_path_for(resource)
    users_path 
  end

  protected
  def after_sign_in_path(resource)
    users_path
  end

end

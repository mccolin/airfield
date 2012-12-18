# AIRFIELD
# ApplicationController -- all application controllers inherit from
#  this base controller

class ApplicationController < ActionController::Base
  protect_from_forgery

  protected

  # Update ActiveAdmin login to use the admin flag column
  def authenticate_admin_user!
    redirect_to new_user_session_path unless current_user.try(:admin?)
  end

end

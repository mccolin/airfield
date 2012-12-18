# AIRFIELD
# User -- individual users/authors/admins of the site

class User < ActiveRecord::Base

  # Scopes:
  scope :admins, where(:admin=>true)

  # Devise Functionality:
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

  # Attributes:
  attr_accessible :admin, :email, :first_name, :last_name, :password, :password_confirmation, :remember_me


  # Smart name combination
  def name
    first_name && last_name ? "#{first_name} #{last_name}" : (first_name ? first_name : last_name)
  end

end

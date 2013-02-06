# AIRFIELD
# User -- individual users/authors/admins of the site

class User < ActiveRecord::Base

  # Relationships:
  has_many :pages, :foreign_key=>"author_id"
  has_many :posts, :foreign_key=>"author_id"
  has_many :images, :foreign_key=>"author_id"

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

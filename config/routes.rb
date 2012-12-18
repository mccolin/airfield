# AIRFIELD
# Routing

Airfield::Application.routes.draw do
  ActiveAdmin.routes(self)

  devise_for :users, ActiveAdmin::Devise.config

  root :to=>"site#index", :as=>"home"

end

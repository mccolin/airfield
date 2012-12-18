# AIRFIELD
# Routing

Airfield::Application.routes.draw do
  ActiveAdmin.routes(self)

  devise_for :users, ActiveAdmin::Devise.config

  root :to=>"site#index", :as=>"home"

  # TODO: Replace with more resourceful routing
  get "page/:id" => "site#page", :as=>"page"
  get "post/:id" => "site#post", :as=>"post"

end

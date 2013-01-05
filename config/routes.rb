# AIRFIELD
# Routing

Airfield::Application.routes.draw do

  get "heartbeat" => "heartbeat#index", :as=>"heartbeat"

  ActiveAdmin.routes(self)

  devise_for :users, ActiveAdmin::Devise.config

  root :to=>"site#index", :as=>"home"

  # TODO: Replace with more resourceful routing

  # Content management:
  resource :content, :controller=>"content", :only=>[:create, :update, :destroy]

  # Site display of posts, categories, and pages:
  get "post/:id" => "site#post", :as=>"post"
  get "category/:id" => "site#category", :as=>"category"
  get ":id" => "site#page", :as=>"page"

end

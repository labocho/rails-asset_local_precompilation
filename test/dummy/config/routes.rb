Rails.application.routes.draw do
  resources :notes
  mount Ckeditor::Engine => "/ckeditor"
  root to: "home#show"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

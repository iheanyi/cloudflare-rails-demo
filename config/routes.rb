Rails.application.routes.draw do
  root "boards#show"

  resources :boards, only: [ :show ] do
    resources :cards, only: [ :create, :edit, :update, :destroy ] do
      member { patch :move }
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end

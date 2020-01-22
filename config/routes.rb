Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :clients, only: [:index]
  resources :users, only: [:create] do
    post :register_name # ユーザ名の登録
    post :regenerate_token, on: :collection # アクセストークンの再取得
    get :status
    get :events
  end
  resources :masterdata, only: [:index]
end

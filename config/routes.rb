# == Route Map
#
#                 Prefix Verb URI Pattern                             Controller#Action
#                clients GET  /clients(.:format)                      clients#index
#     user_register_name POST /users/:user_id/register_name(.:format) users#register_name
# regenerate_token_users POST /users/regenerate_token(.:format)       users#regenerate_token
#            user_status GET  /users/:user_id/status(.:format)        users#status
#            user_events POST /users/:user_id/events(.:format)        users#events
#       user_equips_edit POST /users/:user_id/equips/edit(.:format)   equips#edit
#                  users POST /users(.:format)                        users#create
#             masterdata GET  /masterdata(.:format)                   masterdata#index

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :clients, only: [:index]
  resources :users, only: [:create] do
    post :register_name # ユーザ名の登録
    post :regenerate_token, on: :collection # アクセストークンの再取得
    get :status
    post :events
    # 複数の装備をまとめて編集するので :edit とは別アクション
    post "equips/edit", to: 'equips#edit'
  end
  resources :masterdata, only: [:index]
end

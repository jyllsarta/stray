# == Route Map
#
#                 Prefix Verb URI Pattern                             Controller#Action
#                clients GET  /clients(.:format)                      clients#index
#     user_register_name POST /users/:user_id/register_name(.:format) users#register_name
# regenerate_token_users POST /users/regenerate_token(.:format)       users#regenerate_token
#            user_status GET  /users/:user_id/status(.:format)        users#status
#            user_events POST /users/:user_id/events(.:format)        users#events
#         user_resurrect POST /users/:user_id/resurrect(.:format)     users#resurrect
#       user_equips_edit POST /users/:user_id/equips/edit(.:format)   equips#edit
#                  users POST /users(.:format)                        users#create
#               messages GET  /messages(.:format)                     messages#index
#                        POST /messages(.:format)                     messages#create
#             masterdata GET  /masterdata(.:format)                   masterdata#index

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :clients, only: [:index]
  resources :users, only: [:create] do
    post :register_name # ユーザ名の登録
    post :regenerate_token, on: :collection # アクセストークンの再取得
    get :status
    post :events
    post :resurrect
    # 複数の装備をまとめて編集するので :edit とは別アクション
    post "equips/edit", to: 'equips#edit'
  end
  resources :messages, only: [:index, :create]
  resources :masterdata, only: [:index]

  if Rails.env.development?
    resources :debug, only: [] do
      post :max_event, on: :collection
      post :get_all_items, on: :collection
    end
  end
end

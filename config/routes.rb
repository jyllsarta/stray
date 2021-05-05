# == Route Map
#
#                                     Prefix Verb URI Pattern                                                     Controller#Action
#                                       root GET  /                                                               clients#index
#                                    clients GET  /clients(.:format)                                              clients#index
#                     user_user_item_rank_up POST /users/:user_id/user_items/:user_item_id/rank_up(.:format)      user_items#rank_up
# receive_reward_user_user_achievement_steps POST /users/:user_id/user_achievement_steps/receive_reward(.:format) user_achievement_steps#receive_reward
#                         user_register_name POST /users/:user_id/register_name(.:format)                         users#register_name
#                     regenerate_token_users POST /users/regenerate_token(.:format)                               users#regenerate_token
#                                user_status GET  /users/:user_id/status(.:format)                                users#status
#                               user_profile GET  /users/:user_id/profile(.:format)                               users#profile
#                                  user_deck GET  /users/:user_id/deck(.:format)                                  users#deck
#                           user_won_enemies GET  /users/:user_id/won_enemies(.:format)                           users#won_enemies
#                          user_achievements GET  /users/:user_id/achievements(.:format)                          users#achievements
#                                user_events POST /users/:user_id/events(.:format)                                users#events
#                             user_resurrect POST /users/:user_id/resurrect(.:format)                             users#resurrect
#                        user_switch_dungeon POST /users/:user_id/switch_dungeon(.:format)                        users#switch_dungeon
#               user_switch_returns_on_death POST /users/:user_id/switch_returns_on_death(.:format)               users#switch_returns_on_death
#                           user_equips_edit POST /users/:user_id/equips/edit(.:format)                           equips#edit
#                                      users POST /users(.:format)                                                users#create
#                                     relics POST /relics(.:format)                                               relics#create
#                                   messages GET  /messages(.:format)                                             messages#index
#                                            POST /messages(.:format)                                             messages#create
#                              release_notes GET  /release_notes(.:format)                                        release_notes#index
#                               manual_index GET  /manual(.:format)                                               manual#index
#                                 masterdata GET  /masterdata(.:format)                                           masterdata#index
#                               enemy_engage POST /enemies/:enemy_id/engage(.:format)                             enemies#engage
#                             enemy_showdown POST /enemies/:enemy_id/showdown(.:format)                           enemies#showdown
#                                    enemies GET  /enemies(.:format)                                              enemies#index
#                               equip_skills POST /skills/equip(.:format)                                         skills#equip
#                                     skills GET  /skills(.:format)                                               skills#index
#                                     quests GET  /quests(.:format)                                               quests#index
#                      complete_achievements POST /achievements/complete(.:format)                                achievements#complete
#                         cache_achievements GET  /achievements/cache(.:format)                                   achievements#cache
#                                gacha_index GET  /gacha(.:format)                                                gacha#index
#                                      gacha POST /gacha(.:format)                                                gacha#update
#                    clear_quest_debug_index POST /debug/clear_quest(.:format)                                    debug#clear_quest
#                    reset_quest_debug_index POST /debug/reset_quest(.:format)                                    debug#reset_quest
#                set_achievement_debug_index POST /debug/set_achievement(.:format)                                debug#set_achievement
#              clear_achievement_debug_index POST /debug/clear_achievement(.:format)                              debug#clear_achievement
#              open_all_dungeons_debug_index POST /debug/open_all_dungeons(.:format)                              debug#open_all_dungeons
#                      max_event_debug_index POST /debug/max_event(.:format)                                      debug#max_event
#                open_all_quests_debug_index POST /debug/open_all_quests(.:format)                                debug#open_all_quests
#                     some_event_debug_index POST /debug/some_event(.:format)                                     debug#some_event
#                  get_all_items_debug_index POST /debug/get_all_items(.:format)                                  debug#get_all_items
#              set_all_item_rank_debug_index POST /debug/set_all_item_rank(.:format)                              debug#set_all_item_rank
#                       set_coin_debug_index POST /debug/set_coin(.:format)                                       debug#set_coin
#               edit_gacha_point_debug_index POST /debug/edit_gacha_point(.:format)                               debug#edit_gacha_point
#                       set_star_debug_index POST /debug/set_star(.:format)                                       debug#set_star
#                      set_depth_debug_index POST /debug/set_depth(.:format)                                      debug#set_depth
#                   set_velocity_debug_index POST /debug/set_velocity(.:format)                                   debug#set_velocity
#          learn_all_user_skills_debug_index POST /debug/learn_all_user_skills(.:format)                          debug#learn_all_user_skills

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get root to: "clients#index"
  resources :clients, only: [:index]
  resources :users, only: [:create] do
    resources :user_items, only: [] do
      post :rank_up
    end
    resources :user_achievement_steps, only: [] do
      # 本来の筋で行くとuser_achievement_step_id 指定が正しいんだけど...
      # achievement_step_id 指定の方が楽なので on:collection で余計なパラメータを挟まないようにする
      post :receive_reward, on: :collection
    end
    post :register_name # ユーザ名の登録
    post :regenerate_token, on: :collection # アクセストークンの再取得
    get :status
    get :profile
    get :deck
    get :won_enemies
    get :achievements
    post :events
    post :resurrect
    post :switch_dungeon
    post :switch_returns_on_death
    # 複数の装備をまとめて編集するので :edit とは別アクション
    post "equips/edit", to: 'equips#edit'
  end
  resources :relics, only: [:create]
  resources :messages, only: [:index, :create]
  resources :release_notes, only: [:index]
  resources :manual, only: [:index]
  resources :masterdata, only: [:index]

  resources :enemies, only: [:index] do
    post :engage
    post :showdown
  end

  resources :skills, only: [:index] do
    post :equip, on: :collection
  end

  resources :quests, only: [:index]

  resources :achievements, only: [] do
    post :complete, on: :collection
    get :cache, on: :collection
  end

  resources :gacha, only: [:index] 
  post :gacha, to: "gacha#update"

  if Rails.env.development?
    resources :debug, only: [] do
      DebugController.action_methods.each do |method|
        post method, on: :collection
      end
    end
  end
end

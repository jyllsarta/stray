class QuestsController < ApplicationController
  def index
    @visible_quests = Quest.all.select { |quest| quest.visible?(current_user) }
    @user = current_user
    @today_reward_received = current_user.status.today_raid_reward_status.received_amount
    @today_reward_limit = current_user.status.raid_reward_receivable_limit
  end
end

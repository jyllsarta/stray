class QuestsController < ApplicationController
  def index
    @visible_quests = Quest.all.select { |quest| quest.visible?(current_user) }
    @user = current_user
  end
end

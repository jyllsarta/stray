class MessagesController < ApplicationController
  class EmptyRequest < StandardError; end

  def create
    raise EmptyRequest if params[:message].blank?
    Message.create!(user_id: current_user.id, message: params[:message])
    render json: {success: true}, status: :ok
  end

  def index
    @messages = Message.all.order(created_at: :desc)
  end
end

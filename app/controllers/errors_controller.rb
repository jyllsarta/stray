# https://qiita.com/QUANON/items/e701a0f1e4269771ee24 を参考にエラーハンドラを書く
class ErrorsController < ActionController::Base
  def show
    exception = ErrorManager.find_exception(request.env['action_dispatch.exception'].class)
    render json: { success: false, message: request.env['action_dispatch.exception'].class.to_s }, status: :internal_server_error and return unless exception
    render json: { success: false, message: exception['message'] }, status: exception['status'].to_sym
  end
end
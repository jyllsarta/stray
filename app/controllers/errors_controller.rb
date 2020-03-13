# https://qiita.com/QUANON/items/e701a0f1e4269771ee24 を参考にエラーハンドラを書く
class ErrorsController < ActionController::Base
  def show
    exception = request.env['action_dispatch.exception']
    status = request.path[%r{(?<=\A/)\d{3}\z}]
    render json: { success: false, message: exception.message }, status: ErrorManager.status(exception.class.to_s)
  end
end
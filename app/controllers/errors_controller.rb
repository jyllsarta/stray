# https://qiita.com/QUANON/items/e701a0f1e4269771ee24 を参考にエラーハンドラを書く
class ErrorsController < ActionController::Base # not ApplicationController
  def show
    exception = request.env['action_dispatch.exception']
    status = request.path[%r{(?<=\A/)\d{3}\z}] # request.path[1..-1] でも OK

    render(json: { error: exception.message, status: status }, status: status)
  end
end
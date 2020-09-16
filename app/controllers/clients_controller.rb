class ClientsController < ApplicationController
  def index
    @version = Constants.version
  end
end

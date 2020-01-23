class MasterdataController < ApplicationController
  def index
    @items = Item.all
  end
end

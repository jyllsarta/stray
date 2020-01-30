class MasterdataController < ApplicationController
  def index
    @items = Item.all.map do |item|
      [item.id, item.attributes]
    end.to_h
  end
end

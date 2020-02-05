class MasterdataController < ApplicationController
  def index
    @items = Item.all.map do |item|
      [item.id, item.attributes]
    end.to_h
    @dungeons = Dungeon.all.map do |dungeon|
      [dungeon.id, dungeon.attributes]
    end.to_h
  end
end

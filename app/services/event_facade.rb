class EventFacade
  def get_and_execute_latest_events!(user)
    events = []
    2.times do #TODO: 実施回数を現在時刻ベースで決定する
      events.append(pick_random_event)
    end

    events.each do |event|
      event.execute!(user)
    end
    events
  end

  def pick_random_event
    ItemEvent.new
  end
end

class EventFacade
  def get_and_execute_latest_events!(user)
    events = []
    2.times do
      events.append(pick_random_event)
    end
    events
  end

  def pick_random_event
    ItemEvent.new
  end
end
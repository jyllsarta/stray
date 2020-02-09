class EventFacade
  def initialize
    @now = Time.now
  end

  def get_and_execute_latest_events!(user)
    events = []
    ActiveRecord::Base.transaction do
      user.lock!
      user.status.calibrate_event_updated_at(@now)
      event = pick_next_event(user)
      while next_event_available?(user, event)
        events.append(event)
        event.execute!(user)
        user.status.tick_timer!(event.consume_time)
        event = pick_next_event(user)
      end
    end
    events
  end

  def pick_next_event(user)
    EventPicker.new(user).pick!
  end

  def next_event_available?(user, event)
    @now - user.status.event_updated_at > event.consume_time
  end
end

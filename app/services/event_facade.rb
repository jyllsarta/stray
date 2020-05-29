class EventFacade
  def initialize
    @now = Time.now
  end

  def get_and_execute_latest_events!(user)
    events = []
    ActiveRecord::Base.transaction do
      user.lock!
      calibrate_event = needs_calibrate?(user) ? CalibrateEvent.new(Time.now, user.status.current_dungeon_rank).execute!(user) : nil
      event = pick_next_event(user)
      while next_event_available?(user, event)
        events.append(event)
        event.execute!(user)
        user.status.tick_timer!(event.consume_time(user))
        event = pick_next_event(user)
      end
      events.push(calibrate_event) if calibrate_event.present?
    end
    events
  end

  private


  def needs_calibrate?(user)
    user.status.event_remain_time(Time.now) > Constants.max_event_consume_time_seconds
  end

  def pick_next_event(user)
    EventPicker.new(user).pick!
  end

  def next_event_available?(user, event)
    @now - user.status.event_updated_at >= event.consume_time(user)
  end
end

class EventFacade
  def initialize
    @now = Time.now
  end

  def get_and_execute_latest_events!(user)
    events = []
    preload_associations!(user)
    user.with_lock do
      user.achievement_logger.post(Achievement::Event::LongTimeAbsent.new(user, user.status.event_remain_time(Time.now)))
      calibrate_event = needs_calibrate?(user) ? CalibrateEvent.new(Time.now, user.status.current_dungeon_rank).execute(user) : nil
      event = pick_next_event(user)
      while next_event_available?(user, event)
        events.append(event)
        event.execute(user)
        event.save_status
        user.status.tick_timer(event.consume_time(user))
        user.status.attenuate_velocity
        event = pick_next_event(user)
      end
      user.status.save!
      user.characters.map(&:save!)
      user.status.current_dungeon_progress.save!
      changed_items = user.status.memoized_items_hash.values.select{ |item| item.changed? || !item.persisted? }
      User::Item.import!(changed_items, on_duplicate_key_update: [:rank])
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

  def preload_associations!(user)
    ActiveRecord::Associations::Preloader.new.preload( user, {characters: []})
  end
end

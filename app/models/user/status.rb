class User::Status < ApplicationRecord
  belongs_to :user

  def tick_timer!(seconds)
    self.event_updated_at += seconds
    save!
  end

  def calibrate_event_updated_at(time)
    self.event_updated_at = [self.event_updated_at, time - Constants.max_event_consume_time_seconds].max
    save!
  end
end

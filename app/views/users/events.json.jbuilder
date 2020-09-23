json.version Constants.version
json.events do
  json.array! @events, :type, :detail, :logs
end
json.next_event_at @next_event_at.to_i
json.after_velocity @after_velocity

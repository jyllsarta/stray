json.version "0.0.1"
json.events do
  json.array! @events, :type, :detail
end
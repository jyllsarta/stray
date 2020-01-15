json.version "0.0.1"
json.events do
  json.array! [{type: :item, payload: {id: 1, lv: 1}}, {type: :stair, payload: {depth: 2}}], :type, :payload
end

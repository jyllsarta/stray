json.enemies do
  json.array! @enemies, :id, :name, :hp, :rank
end

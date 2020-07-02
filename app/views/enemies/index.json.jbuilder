json.enemies do
  json.array! @enemies, :id, :name, :hp, :denomination_factor
end

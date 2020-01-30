json.masterdata do
  json.items do
    json.array! @items, :name, :str, :dex, :def, :agi
  end
end

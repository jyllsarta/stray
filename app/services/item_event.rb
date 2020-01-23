class ItemEvent < Event
  def type
    "Item"
  end
  def detail
    {
      id: 2,
      amount: 5  
    }
  end
end
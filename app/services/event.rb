class Event
  def type
    raise NotImplementedError
  end
  def detail
    raise NotImplementedError
  end
  def log
    raise NotImplementedError
  end
  def execute!
    raise NotImplementedError
  end
  def consume_time
    raise NotImplementedError
  end
end

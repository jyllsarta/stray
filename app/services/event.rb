class Event
  def type
    raise NotImplementedError
  end
  def detail
    raise NotImplementedError
  end
  # 戦闘イベントなどは1イベントで複数行ログ出力する可能性がある
  def logs
    raise NotImplementedError
  end
  def execute!
    raise NotImplementedError
  end
  def consume_time
    raise NotImplementedError
  end
end

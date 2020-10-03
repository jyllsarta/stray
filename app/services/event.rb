class Event
  attr_reader :status

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
  def execute
    raise NotImplementedError
  end
  def consume_time
    raise NotImplementedError
  end
  def save_status
    @status = {
      at: @at.to_i,
      characters: {
        spica: {
          # TODO: preload の結果を生かしつつ [0][1] のアクセスをさせない安全な方法を考える
          hp: @user.characters[0].hp,
          hp_max: @user.characters[0].hp_max,
          exp: @user.characters[0].exp,
          level: @user.characters[0].level,
        },
        tirol: {
          hp: @user.characters[1].hp,
          hp_max: @user.characters[1].hp_max,
          exp: @user.characters[1].exp,
          level: @user.characters[1].level,
        },
      },
      current_dungeon_depth: @user.status.current_dungeon_depth,
      coin: @user.status.coin,
      star: @user.status.star,
      velocity: @user.status.velocity
    }
  end
end

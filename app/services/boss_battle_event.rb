class BossBattleEvent < Event

  def initialize(rank=0, at=Time.now)
    @at = at
    @rank = rank
  end

  def type
    "boss_battle"
  end

  def detail
    {
        damages: @battle.damages
    }
  end

  def logs
    [
        {
            at: @at.to_i,
            message: log_messages
        }
    ]
  end

  def execute!(user)
    @battle = Battle.new(user, boss(@rank))
    @battle.execute!
    @battle.apply_damages!
    @battle.is_win ? process_win(user) : process_lose(user)
  end

  def consume_time(user)
    Constants.default_event_interval_seconds - user.status.event_wait_reduction_seconds
  end

  private

  def process_win(user)
    # ロックはイベント処理全体のほうで取られているのでこっちでは取得していない
    @received_star = user.status.dungeon.boss_reward_star_amount
    user.status.add_star!(@received_star)
    user.status.increment!(:current_dungeon_depth, 1)
    user.status.current_dungeon_progress.dig_to!(user.status.current_dungeon_depth)
  end

  def process_lose(user)
    user.status.decrement!(:current_dungeon_depth, Constants.event.battle.boss_lose_rewind_floor)
    user.status.start_resurrect_timer!
  end

  def log_messages
    @battle.is_win ? win_log : lose_log
  end

  def win_log
    damages = @battle.damages
    "[勝利]ボス戦だ！#{@battle.turn}ターン継続し、スピカ#{damages[0]}、チロル#{damages[1]}ダメージを負ったが無事勝利！\n星のカケラを#{@received_star}個手に入れた！"
  end

  def lose_log
    damages = @battle.damages
    "[敗北]ボス戦だ！#{@battle.turn}ターン継続し、スピカ#{damages[0]}、チロル#{damages[1]}ダメージ。敗北したので#{Constants.event.battle.boss_lose_rewind_floor}F戻された！"
  end

  def boss(rank)
    [BattleCharacter.new_boss(rank)]
  end
end

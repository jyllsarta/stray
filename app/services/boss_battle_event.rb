class BossBattleEvent < Event

  def initialize(rank=0, at=Time.now)
    @at = at
    @rank = (rank * Constants.event.battle.enemy_rank_factor + Constants.event.battle.enemy_rank_geta).floor
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

  def consume_time
    Constants.default_event_interval_seconds
  end

  private

  def process_win(user)
    user.status.increment!(:current_dungeon_depth, 1)
    user.status.current_dungeon_progress.dig_to!(user.status.current_dungeon_depth)
  end

  def process_lose(user)
    user.status.decrement!(:current_dungeon_depth, Constants.event.battle.boss_lose_rewind_floor)
    user.status.start_resurrect_timer!
  end

  def rank_ratio(enemy_rank, character_rank)
    [(enemy_rank - character_rank) / 2, 1].max
  end

  def log_messages
    @battle.is_win ? win_log : lose_log
  end

  def win_log
    damages = @battle.damages
    "[勝利]ボス戦だ！#{@battle.turn}ターン継続し、スピカ#{damages[0]}、チロル#{damages[1]}ダメージを負ったが無事勝利！次の階層が解放された！"
  end

  def lose_log
    damages = @battle.damages
    "[敗北]ボス戦だ！#{@battle.turn}ターン継続し、スピカ#{damages[0]}、チロル#{damages[1]}ダメージ。敗北したので#{Constants.event.battle.boss_lose_rewind_floor}F戻された！"
  end

  def boss(rank)
    [BattleCharacter.new_boss(rank)]
  end
end

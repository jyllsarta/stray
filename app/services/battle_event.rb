class BattleEvent < Event

  def initialize(rank=0, at=Time.now)
    @at = at
    # バトルイベントの強さは矯正する
    @rank = rank
  end

  def type
    "battle"
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
    @battle = Battle.new(user, lot_enemies!(@rank))
    @battle.execute!
    @battle.apply_damages!
    @battle.is_win ? process_win(user) : process_lose(user)
    fluctuate_velocity!(user)
  end

  def consume_time(user)
    [Constants.default_event_interval_seconds - user.status.event_wait_reduction_seconds, Constants.minimum_event_interval_seconds].max
  end

  private

  def coin_amount
    @rank * 10
  end

  def process_win(user)
    exp = Constants.event.battle.base_exp + SecureRandom.rand(0..Constants.event.battle.additional_exp_range)
    user.characters.each do |character|
      next if character.dead?
      multiplier = rank_ratio(@rank, character.level)
      character.gain_exp!(exp * multiplier)
    end
    user.status.add_coin!(coin_amount)
  end

  def fluctuate_velocity!(user)
    if @battle.is_win
      delta = Constants.event.battle.velocity_delta.send("turn#{@battle.turn}") || Constants.event.battle.velocity_delta.other
      user.status.fluctuate_velocity!(delta)
    else
      user.status.fluctuate_velocity!(-9999)
    end
  end

  def process_lose(user)
    user.status.start_resurrect_timer!
  end

  def rank_ratio(enemy_rank, character_rank)
    [(enemy_rank - character_rank) / 2, 1].max
  end

  def log_messages
    damages = @battle.damages
    "[#{@battle.is_win ? '勝利' : '敗北'}]戦闘だ!#{@battle.turn}T継続,スピカ#{damages[0]},チロル#{damages[1]}ダメージ。#{@battle.is_win ? "#{coin_amount}コイン手にいれた！" : ''}"
  end

  def lot_enemies!(rank)
    # TODO 敵にバリエーションを出す
    [BattleCharacter.new_enemy(rank), BattleCharacter.new_enemy(rank), BattleCharacter.new_enemy(rank)]
  end
end

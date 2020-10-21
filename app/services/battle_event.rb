class BattleEvent < Event
  attr_reader :is_win, :turn

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

  def execute(user)
    @user = user
    @battle = Battle.new(user, lot_enemies!(@rank))
    @battle.execute
    @battle.apply_damages
    @battle.is_win ? process_win(user) : process_lose(user)
    fluctuate_velocity(user)
    user.achievement_logger.post(Achievement::Event::BattleEvent.new(user, self))
  end

  def consume_time(user)
    [Constants.default_event_interval_seconds - user.status.event_wait_reduction_seconds, Constants.minimum_event_interval_seconds].max
  end

  private

  def base_coin_amount
    @rank * 10
  end

  def process_win(user)
    exp = Constants.event.battle.base_exp + SecureRandom.rand(0..Constants.event.battle.additional_exp_range)
    user.characters.each do |character|
      next if character.dead?
      multiplier = rank_ratio(@rank, character.level)
      character.gain_exp(exp * multiplier)
    end
    @coin_multiplier = [user.status.velocity_rank, 1].max
    @coin_amount = base_coin_amount * @coin_multiplier
    user.status.add_coin(@coin_amount)
  end

  def fluctuate_velocity(user)
    if @battle.is_win
      delta = Constants.event.battle.velocity_delta.send("turn#{@battle.turn}") || Constants.event.battle.velocity_delta.other
      user.status.fluctuate_velocity(delta)
    else
      user.status.fluctuate_velocity(-9999)
    end
  end

  def process_lose(user)
    user.status.start_resurrect_timer
  end

  def rank_ratio(enemy_rank, character_rank)
    [(enemy_rank - character_rank) / 2, 1].max
  end

  def log_messages
    damages = @battle.damages
    "[#{battle_result_mark_message}]戦闘だ!#{@battle.turn}T継続,スピカ#{damages[0]},チロル#{damages[1]}ダメージ。#{coin_message}"
  end

  def coin_message
    return "" unless @battle.is_win
    multiplied = @coin_multiplier > 1 ? '多めに' : ''
    "#{multiplied}#{@coin_amount}コイン手にいれた！"
  end

  def battle_result_mark_message
    return "敗北" unless @battle.is_win
    buster_level = Constants.event.battle.buster_level[@battle.turn] || Constants.event.battle.default_buster_level
    "#{buster_level}勝利"
  end

  def lot_enemies!(rank)
    # TODO 敵にバリエーションを出す
    [BattleCharacter.new_enemy(rank), BattleCharacter.new_enemy(rank), BattleCharacter.new_enemy(rank)]
  end
end

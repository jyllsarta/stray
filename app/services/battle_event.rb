class BattleEvent < Event
  def initialize(rank=0, at=Time.now)
    @at = at
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
    @battle = Battle.new(user, 1)
    @battle.execute!
    @battle.apply_damages!
    @battle.is_win ? process_win(user) : process_lose(user)
  end

  def consume_time
    Constants.default_event_interval_seconds
  end

  private

  def process_win(user)
    exp = Constants.event.battle.base_exp + SecureRandom.rand(0..Constants.event.battle.additional_exp_range)
    user.characters.each do |character|
      next if character.dead?
      multiplier = rank_ratio(@rank, character.level)
      character.gain_exp!(exp * multiplier)
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
    "[#{@battle.is_win ? '勝利' : '敗北'}]戦闘が発生した！ スピカ#{damages[0]}, チロル#{damages[1]}ダメージ。"
  end
end

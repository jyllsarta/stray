class SessionId
  def initialize(user)
    @user = user
  end

  def expired?(session_id, opened_at)
    # キャッシュが無いなら初回アクセスとしてみなす
    return false if read.blank?

    cache = read
    # キャッシュがある場合
    # 同セッションIDだった場合は同じウィンドウからのアクセスなのでOK
    return false if cache[:session_id] == session_id

    # 別ウィンドウからのアクセスの場合(=セッションIDが相違する場合)、opened_at が古かったら新しいウィンドウですでにプレイされているのでNG
    return cache[:opened_at] > opened_at
  end

  def write(session_id, opened_at)
    Rails.cache.write(key,
                      {
                          session_id: session_id,
                          opened_at: opened_at
                      }.to_json)
  end

  private

  def read
    cache = Rails.cache.read(key)
    return nil if cache.blank?
    JSON.parse(cache, symbolize_names: true)
  end

  def key
    "session_id:#{@user.id}"
  end
end

class SessionId
  class Expired < StandardError; end

  def initialize(user)
    @user = user
  end

  def verify!(session_id, session_started_at)
    raise Expired if expired?(session_id, session_started_at)
  end

  def write(session_id, session_started_at)
    Rails.cache.write(key,
                      {
                          session_id: session_id,
                          session_started_at: session_started_at
                      }.to_json)
  end

  def expired?(session_id, session_started_at)
    # キャッシュが無いなら初回アクセスとしてみなす
    return false if read.blank?

    cache = read
    # キャッシュがある場合
    # 同セッションIDだった場合は同じウィンドウからのアクセスなのでOK
    return false if cache[:session_id] == session_id

    # 別ウィンドウからのアクセスの場合(=セッションIDが相違する場合)、opened_at が古かったら新しいウィンドウですでにプレイされているのでNG
    return cache[:session_started_at] > session_started_at
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

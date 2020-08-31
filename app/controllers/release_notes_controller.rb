class ReleaseNotesController < ApplicationController
  def index
    # TODO: マスタを作成するまでは一旦これでいいや
    @release_notes = [
      OpenStruct.new(
        version: "0.2.0",
        published_at: Time.parse("2020/9/1"),
        content: "## 概要\n\nこのリリースノート機能を実装しました。\n\n色々たくさん報告いただいておりますが、まずは体制を整えるところからやっていきます...!\nおいおいここで修正対応とフィードバックへの返信をやっていきたいですね"
      ),
      OpenStruct.new(
        version: "0.1.0",
        published_at: Time.parse("2020/8/31"),
        content: "## 概要\n\n公開しました。\n(初手ぶえーしてたけど、それは気にしない)"
      ),
    ]
  end
end

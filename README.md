[![codecov](https://codecov.io/gh/jyllsarta/stray/branch/master/graph/badge.svg)](https://codecov.io/gh/jyllsarta/stray)

# スピカとチロル

https://st.jyllsarta.net/

装備をとっかえひっかえしながら世界各所の妖精たちと熾烈なバトルを繰り広げる放置系ブラウザゲーです。
お手軽なかわいさとトライアンドエラー前提の奥深い戦略を楽しめるRPG

公式サーバは上記URLから飛べます。

## ローカル環境について

自分自身で遊ぶ環境を構築できます。
とはいってもインストーラーなどは存在せず、Rubyとその他開発環境を自力で用意することになるのでかなりエンジニア向け

CircleCIでテストする機構を用意してあるので、読める人は `.circle/config.yml` を読めば大体の環境構築手順がわかります。

## インストール

ブラウザで http://localhost:3000/ にアクセスしたらゲームが動き出すのを目標にします。

### インストールでつまづいたら

https://github.com/jyllsarta/stray/issues ここの `New issue`  を押すと色々入力できるので、そこに以下の項目を入力し、 `Submit New Issue` ボタンを押してください。質問トピックが作れます。

* この手順のどこでインストールに失敗するのか
* 具体的にうまくいっていないこと
* (あれば)実際にターミナルに表示されたエラーと、その前後20行くらいのターミナルのテキストのコピー

### 前提となる環境構築

#### CLIの準備

Macであればターミナル、WindowsであればWSLの `ubuntu 18.04` 環境を用意してください。
お手元に黒い画面は用意できたでしょうか。

#### MySQLサーバーとRedisサーバーを立てる

どうにかして、RedisサーバーとMySQLサーバーとNode.js(v14.4.0)がお手元の環境で動いている状況を作ってください。
Dockerが使えればそれが一番簡単です。使えない方は `mac mysql インストール` など検索して対応しましょう。
Node.js に関しては https://qiita.com/1000ch/items/41ea7caffe8c42c5211c に従うのがおすすめです。

```shell
$ redis-cli
127.0.0.1:6379>
```

```shell
$ mysql
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 158
Server version: 5.6.46 MySQL Community Server (GPL)

Copyright (c) 2000, 2019, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql>
```

```shell
$ node -v
v14.4.0
```

こうなれば成功です。
MySQLのバージョンは5.6でも5.7でも動作しますが、このふたつ以外では動作確認していません。

#### rubyの環境構築

どうにかして、rubyの3.0.1が動いている状況を作ってください。

https://dev.classmethod.jp/articles/build-ruby-environment-by-rbenv/

この記事に従うのがおすすめです。

```shell
$ ruby -v
ruby 3.0.1p64 (2021-04-05 revision 0fb782ee38) [x86_64-linux]
```

こうなれば成功です。

#### クローン

githubからソースコードを落としてきます。

```shell
$ cd ~
$ git clone git@github.com:jyllsarta/stray.git
```

マスターデータも落としてきます。ここ以外のパスでも問題ありませんが、その場合は `.env` でパスの指定が必要になります。

```shell
$ cd ~/stray
$ git clone git@github.com:jyllsarta/stray-masterdata.git masterdata
```

### インストール

#### dotenvの編集

`dotenv.example` を参考に、環境変数を設定します。

```shell
$ cd ~/stray
$ cp dotenv.example .env
$ vim dotenv.example
```

MYSQL_USERNAME と MYSQL_PASSWORD はお手元の環境で設定したものに編集しましょう。その他は基本的に変更不要です。

#### bundle installを成功させる

```shell
$ cd ~/stray
$ bundle install
```

環境依存で色々エラーが出る可能性がありますが、その場合はエラーメッセージでググって個別に解決しましょう。

#### yarn installを成功させる

```shell
$ cd ~/stray
$ yarn insall
```

環境依存で色々エラーが出る可能性がありますが、その場合はエラーメッセージでググって個別に解決しましょう。

#### テストの実行

ここまでの手順がすべて成功したかどうかを確かめるために、一回テストを実行しましょう。

```shell
$ bundle exec rails db:reset_test
$ bundle exec rspec
```

うまくいっていればこういった表示になります。

```shell
....................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................
Finished in 28.36 seconds (files took 27.74 seconds to load)
500 examples, 0 failures
```

### データベースの構築

```shell
$ bundle exec rails db:create
$ bundle exec rails db:ridgepole:apply
$ bundle exec rails db:seed
```

これでDBにゲームの動作に必要な一通りのデータが入ります。

### webpack-dev-server

ターミナルのタブを一つ増やしましょう。

```shell
$ cd ~/stray
$ yarn start
```

```shell
 ｢wdm｣: Compiled successfully.
```

様々なファイルがロードされたあと、これが出てくれば成功です。

### rails server

サーバを起動します。

```shell
$ cd ~/stray
$ bundle exec rails server
```

これに成功したら、環境構築は完了です。
サーバを起動した状態で `http://localhost:3000/` にアクセスすると自分だけの環境でゲームが起動します。おめでとう！

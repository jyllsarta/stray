# http://shepherdmaster.hateblo.jp/entry/2016/11/03/225957
# いったんjsonを挟んでからロードすると入れ子が合ってもきれいにOpenStructとしてパースしてくれるらしい
Constants = JSON.parse(YAML.load_file("config/constants.yml").to_json, object_class: OpenStruct).freeze

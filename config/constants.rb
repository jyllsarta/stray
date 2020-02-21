# http://shepherdmaster.hateblo.jp/entry/2016/11/03/225957
# いったんjsonを挟んでからロードすると入れ子があってもきれいにOpenStructとしてパースしてくれるらしい
Constants = JSON.parse(YAML.load(ERB.new(File.read("config/constants.yml.erb")).result).to_json, object_class: OpenStruct).freeze

# fixture_partsをハッシュで返却
# @params parts_yml [string] ymlファイルのパス
#
# @return hash
def read_fixture_parts(parts_yml)
  file = Rails.root.join("test/fixture_parts", parts_yml)
  return YAML.load(ERB.new(file.read).result)
end

# fixture_partsデータのDB登録
# @param records     [hash] key: モデル名, values: hash
# @param description [string] テストデータの件名
# @param puts_errors [bool] エラー出力の有無
def save_value(subject="", record)
  record.each do |model_name, values|
    model = model_name.classify.constantize.new(values)
    model.id = values["id"]
    if !model.save
      puts "#{subject}\n#{model.errors.inspect}"
      raise ActiveRecord::RecordInvalid.new(model)
    end
  end
end

# fixture_partsファイルの一括DB登録
# @param parts_yml [string] ymlファイルのパス
# @param commit    [bool]   コミット有無
def load_fixture_parts(parts_yml, commit:false)
  parts_hash = read_fixture_parts(parts_yml)
  parts_hash.each do |subject, record|
    save_value(subject, record)
  end

  if commit
    ActiveRecord::Base.connection.commit_db_transaction
    ActiveRecord::Base.connection.begin_db_transaction
    ActiveRecord::Base.connection.execute("SAVEPOINT active_record_1;")
  end
end

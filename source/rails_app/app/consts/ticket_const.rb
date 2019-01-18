module TicketConst

  STATUS_LIST = {
    STATUS_DRAFT  =  1 => "新規",
    STATUS_START  =  2 => "進行中",
    STATUS_END    = 10 => "完了",
    STATUS_CANCEL = 11 => "取消",
  }
  # ステータスIDの名前取得
  def self.status_name(status)
    unless STATUS_LIST.keys.include?(status)
      raise "存在しないステータスです。"
    end
    STATUS_LIST[status]
  end

  # ステータス分類
  STATUS_GROUP_IDS = {
    GROUP_PROGRESS = "1" => [STATUS_DRAFT, STATUS_START],
    GROUP_COMPLETE = "2" => [STATUS_END, STATUS_CANCEL],
    GROUP_ALL      = "9" => STATUS_LIST.keys,
  }
  # ステータスIDからグループIDを判定
  # @params status STATUS_LIST[key]
  #
  # @return STATUS_GROUP_IDS[key]
  def self.status_group(status)
    if STATUS_GROUP_IDS[GROUP_PROGRESS].include?(status)
      GROUP_PROGRESS
    elsif STATUS_GROUP_IDS[GROUP_COMPLETE].include?(status)
      GROUP_COMPLETE
    else
      raise "存在しないステータスです。"
    end
  end
end
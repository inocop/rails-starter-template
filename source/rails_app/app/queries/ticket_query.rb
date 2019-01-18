class TicketQuery

  # 対象プロジェクトのチケットリストを取得
  # @params project_id [Int]
  # @params group      [Int] TicketConst::STATUS_GROUP_IDS[key]
  #
  # @return Relation<Ticket>
  def self.tickets_by_project(project_id:, group:)
    rel = Ticket.active.where("project_id = ?", project_id)

    filter(rel, group: group).includes(:user)
  end


  class << self
    private

    # ステータスグループで絞り込み
    # @params group [Int] TicketConst::STATUS_GROUP_IDS[key]
    #
    # @return Relation<Ticket>
    def filter(rel, group:)
      if TicketConst::STATUS_GROUP_IDS.include?(group)
        rel.where(:status => TicketConst::STATUS_GROUP_IDS[group])
      else
        # 存在しないグループIDなので空を返す
        rel.none
      end
    end

  end
end
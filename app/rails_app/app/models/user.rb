class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :name, :presence => true,
                        :length => {:maximum => 50},
                        :uniqueness => {:scope => :deleted_at}

  validates :email, :length => {:maximum => 244} # 論理削除時のprefix分を確保して制限
                    #:uniqueness => {:scope => :deleted_at, :case_sensible => false}

  mount_uploader :image_path, UserImageUploader


  # instead of deleting, indicate the user requested a delete & timestamp it
  def soft_delete
    update_attribute(:deleted_at, Time.current)

    # 論理削除後に同emailで再登録できるよう、deleted_atをprefixにして更新
    deleted_at_email = self.deleted_at.to_i.to_s + '_' + self.email.to_s
    #self.skip_reconfirmation!   # deviseが送信するメールアドレス更新の通知をskip（confirmable利用時）
    update_attribute(:email, deleted_at_email)
  end

  # @override Devise::Models::Authenticatable
  # ensure user account is active
  def active_for_authentication?
    super && !deleted_at
  end

  # @override Devise::Models::Authenticatable
  # provide a custom message for a deleted account
  def inactive_message
    !deleted_at ? super : :unauthenticated
  end
end

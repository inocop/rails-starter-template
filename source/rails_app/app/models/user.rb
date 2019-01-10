# == Schema Information
#
# Table name: users
#
#  id                     :bigint(8)        not null, primary key
#  admin                  :boolean          default(FALSE), not null
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string(255)
#  deleted_at             :datetime
#  email                  :string(300)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  image                  :string(255)
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string(255)
#  name                   :string(255)      not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string(255)
#  sign_in_count          :integer          default(0), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  mount_uploader :image, UserImageUploader

  scope :active, -> {where(deleted_at: nil)}

  validates :name, presence: true,
                   length: {maximum: 50}

  validates :email, presence: true,
                    length: {maximum: 256},
                    uniqueness: {case_sensible: false}

  # instead of deleting, indicate the user requested a delete & timestamp it
  def soft_delete
    ApplicationRecord.transaction do
      current_time = Time.current

      # 論理削除後に同emailで再登録できるよう、deleted_atをprefixにして更新
      deleted_at_email = "#{current_time.to_i.to_s}_#{self.email.to_s}"
      #self.skip_reconfirmation!   # deviseが送信するメールアドレス更新の通知をskip（confirmable利用時）

      update_columns(email: deleted_at_email, deleted_at: current_time) # update_columnsでバリデーションを無視
    end
    return true
  rescue => e
    return false
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

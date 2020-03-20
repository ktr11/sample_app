# userオブジェクトの各フィールドの形式等を定義
class User < ApplicationRecord
  validates(:name, presence: true, length: { maximum: 50 })
  VALID_EMAIL_REGEX = /\A[a-z\d]+[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  validates(:email, presence: true, length: { maximum: 255 },
    format: { with: VALID_EMAIL_REGEX })

end

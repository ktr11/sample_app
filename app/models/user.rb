# userオブジェクトの各フィールドの形式等を定義
class User < ApplicationRecord
  # 保存前にメールアドレスを小文字に
  before_save { email.downcase! }
  # name のvalidation
  validates(:name, presence: true, length: { maximum: 50 })
  # email の validation
  VALID_EMAIL_REGEX =
    /\A[a-z\d]+[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.freeze
  validates(:email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false })
  # セキュアなパスワード
  has_secure_password
  validates(:password, presence: true, length: { minimum: 6 }, allow_nil: true)

  # 渡された文字列のハッシュ値を返す
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
end

class User < ActiveRecord::Base
  attr_reader :password
  validates :username, :password_digest, presence: true
  validates :password, length: { minimum: 6, allow_nil: true }
  after_initialize :ensure_session_token

  has_many :moderated_subs,
    foreign_key: :user_id,
    primary_key: :id,
    class_name: "Sub"

  has_many :posts,
    foreign_key: :user_id,
    primary_key: :id,
    class_name: "Post"


  def self.find_by_credentials(username, password)
    user = User.find_by_username(username)
    return nil if user.nil?
    user.is_password?(password) ? user : nil
  end

  def self.generate_session_token
    SecureRandom::urlsafe_base64(16)
  end

  def reset_session_token!
    self.session_token = User.generate_session_token
    self.save!
    self.session_token
  end

  def password=(value)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  private
  def ensure_session_token
    self.session_token ||= self.class.generate_session_token
  end
end

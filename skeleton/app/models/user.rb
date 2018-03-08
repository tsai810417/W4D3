# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  username        :string           not null
#  password_digest :string           not null
#  session_token   :string
#

class User < ApplicationRecord
  validates :username, :password_digest, :session_token, presence: true
  # validates :password, length: { minimum: 6, allow_nil: true }
  before_validation :ensure_session_token

  def ensure_session_token
    reset_session_token! unless !!self.session_token
  end

  def reset_session_token!
    self.session_token = SecureRandom::urlsafe_base64(16)
    save!
    self.session_token
  end

  def password=(password)
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  def self.find_by_credentials(user_name, password)
    user = User.find_by(username: user_name)
    return user if user && user.is_password?(password)

    nil
  end

end

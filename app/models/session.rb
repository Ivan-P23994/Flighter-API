class Session
  attr_reader :email, :password

  def initialize(email:, password:)
    @email = email
    @password = password
  end

  def valid?
    return false if user.nil?

    user.valid_password?(password)
  end

  def user
    @user ||= User.find_by(email: email)
  end
end

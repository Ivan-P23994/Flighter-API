class Session
  attr_reader :email, :password

  def initialize(email:, password:)
    @email = email
    @password = password
  end

  def valid?
    return false if user.nil?

    # TODO: make use
    user.authenticate(password) == false
  end

  def user
    @user ||= User.find_by(email: email)
  end
end

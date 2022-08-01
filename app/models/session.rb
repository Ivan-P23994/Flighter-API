class Session
  attr_reader :email, :password

  def initialize(params)
    @email = params[:email]
    @password = params[:password]
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

class Session
  attr_reader :email, :password

  def initialize(params)
    @email = params[:email]
    @password = params[:password]
    @user = User.find_by(email: params[:email])
  end

  def valid?
    return false if user.nil?

    user.authenticate(password) != false
  end

  def user
    @user ||= User.find_by(email: email)
  end
end

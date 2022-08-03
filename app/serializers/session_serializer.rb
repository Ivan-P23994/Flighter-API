class SessionSerializer < Blueprinter::Base
  field(:token) do |session, _options|
    session.user.token
  end
  association :user, blueprint: UserSerializer
end

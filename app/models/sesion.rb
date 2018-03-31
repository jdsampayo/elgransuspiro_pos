class Sesion < Authlogic::Session::Base
  authenticate_with Usuario
end

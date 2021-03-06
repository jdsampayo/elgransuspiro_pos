# == Schema Information
#
# Table name: usuarios
#
#  id                 :uuid             not null, primary key
#  email              :text
#  crypted_password   :text
#  password_salt      :text
#  persistence_token  :text
#  created_at         :datetime
#  updated_at         :datetime
#  roles              :string
#  login_count        :integer          default(0), not null
#  failed_login_count :integer          default(0), not null
#  last_request_at    :datetime
#  current_login_at   :datetime
#  last_login_at      :datetime
#  current_login_ip   :string
#  last_login_ip      :string
#

class Usuario < ActiveRecord::Base
  ROLES = [
    accountant: "Contador",
    admin: "Administrador",
    manager: "Encargado",
    waitress: "Mesero"
  ]

  EMAIL = /
    \A
    [A-Z0-9_.&%+\-']+   # mailbox
    @
    (?:[A-Z0-9\-]+\.)+  # subdomains
    (?:[A-Z]{2,25})     # TLD
    \z
  /ix

  acts_as_authentic do |configuration|
    configuration.session_class = Sesion
    configuration.crypto_provider = ::Authlogic::CryptoProviders::SCrypt
  end

  serialize :roles, Array

  validates_presence_of :email, :password, :password_confirmation

  validates :email,
    format: {
      with: EMAIL,
      message: proc {
        ::Authlogic::I18n.t(
          'error_messages.email_invalid',
          default: 'should look like an email address.'
        )
      }
    },
    length: { maximum: 100 },
    uniqueness: {
      case_sensitive: false,
      if: :will_save_change_to_email?
    }

  validates :password,
    confirmation: { if: :require_password? },
    length: {
      minimum: 8,
      if: :require_password?
    }

  validates :password_confirmation,
    length: {
      minimum: 8,
      if: :require_password?
    }

  def to_s
    email
  end

  def accountant?
    roles.include?(:accountant)
  end

  def admin?
    roles.include?(:admin)
  end

  def manager?
    roles.include?(:manager)
  end

  def waitress?
    roles.include?(:waitress)
  end

  def self.pretty_print
    all.each do |user|
      print user.email, user.roles, "\n"
    end
    nil
  end
end

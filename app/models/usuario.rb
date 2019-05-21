# == Schema Information
#
# Table name: usuarios
#
#  id                :uuid             not null, primary key
#  email             :text
#  crypted_password  :text
#  password_salt     :text
#  persistence_token :text
#  created_at        :datetime
#  updated_at        :datetime
#

class Usuario < ActiveRecord::Base
  acts_as_authentic do |configuration|
    configuration.session_class = Sesion
    configuration.validates_format_of_email_field_options = {with: Authlogic::Regex.email_nonascii}
  end

  validates_presence_of :email, :password, :password_confirmation

  def to_s
    email
  end

end

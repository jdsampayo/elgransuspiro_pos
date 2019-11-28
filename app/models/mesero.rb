# == Schema Information
#
# Table name: meseros
#
#  id         :uuid             not null, primary key
#  nombre     :text
#  created_at :datetime
#  updated_at :datetime
#  deleted_at :datetime
#

class Mesero < ApplicationRecord
  has_many :comandas
  has_many :asistencias

  has_one_attached :avatar

  acts_as_paranoid

  def to_s
    nombre
  end

  def public_avatar_url
    if self.avatar&.attachment
      if Rails.env.development?
        @avatar_url = Rails.application.routes.url_helpers.rails_blob_url(self.avatar, only_path: true)
      else
        @avatar_url = self.avatar&.service_url&.split("?")&.first
      end
    end

    @avatar_url ||= '/default.jpg'
  end
end

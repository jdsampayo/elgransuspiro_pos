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
  include Discard::Model

  has_many :comandas
  has_many :asistencias

  has_one_attached :avatar

  self.discard_column = :deleted_at

  DEFAULT_AVATAR = '/default-avatar.png'.freeze

  def to_s
    nombre
  end

  def public_avatar_url
    if self.avatar&.attachment
      @avatar_url = Rails.application.routes.url_helpers.rails_blob_url(self.avatar, only_path: true)
    end

    @avatar_url ||= DEFAULT_AVATAR
  rescue
    @avatar_url = DEFAULT_AVATAR
  end

  def self.por_asistir(current_sucursal)
    Asistencia.meseros_del_dia_por_asistir(current_sucursal)
  end
end

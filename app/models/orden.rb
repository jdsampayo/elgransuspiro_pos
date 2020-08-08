# == Schema Information
#
# Table name: ordenes
#
#  id              :uuid             not null, primary key
#  articulo_id     :uuid
#  comanda_id      :uuid
#  cantidad        :bigint           default(1)
#  precio_unitario :decimal(, )      default(0.0)
#  created_at      :datetime
#  updated_at      :datetime
#  para_llevar     :boolean
#  deleted_at      :datetime
#

class Orden < ApplicationRecord
  include Discard::Model

  belongs_to :articulo
  belongs_to :comanda
  has_many :extra_ordenes

  accepts_nested_attributes_for :extra_ordenes, reject_if: :all_blank, allow_destroy: true

  before_save :guardar_precios_historicos

  scope :ordered, -> { includes(:articulo).order('articulos.nombre') }

  self.discard_column = :deleted_at

  def precio
    cantidad * precio_unitario
  end

  def precio_extras
    extra_ordenes.map(&:precio).sum
  end

  def guardar_precios_historicos
    self.precio_unitario = articulo.precio + precio_extras
  end

  def descontar_desechables
    return unless para_llevar?

    articulo.desechables.each do |desechable|
      desechable.update_attribute(:cantidad, desechable.cantidad - cantidad)
    end
  end

  def to_text
    cantidad.to_s.rjust(2, ' ') + " " +
    articulo.to_s.upcase[0,16].ljust(17, '.') +
    precio_unitario.to_s.rjust(5, '.').ljust(7, ' ') +
    precio.to_s.rjust(5, ' ').ljust(5, ' ')
  end

  def to_s
    ((cantidad > 1) ? "(#{cantidad}) " : "") + articulo.to_s
  end

  def full_name
    return to_s if extra_ordenes.blank?

    to_s + " [#{extra_ordenes.map(&:to_s).to_sentence}]"
  end
end

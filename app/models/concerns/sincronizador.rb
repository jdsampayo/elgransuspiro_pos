module Sincronizador
  extend ActiveSupport::Concern

  NO_SYNC = Rails.application.config.x.sucursal == 'no_sync'

  def syncronize_create
    return if NO_SYNC

    Sincronizacion.create(
      path: self.class.to_s.downcase.pluralize,
      mensaje: self.to_sync_json,
      tipo: "POST"
    )

    SyncronizeJob.perform_later
  end

  def syncronize_update
    return if NO_SYNC

    Sincronizacion.create(
      path: "#{self.class.to_s.downcase.pluralize}/#{self.id}",
      mensaje: self.to_sync_json,
      tipo: "PATCH"
    )

    SyncronizeJob.perform_later
  end

  def syncronize_destroy
    return if NO_SYNC

    Sincronizacion.create(
      path: "#{self.class.to_s.downcase.pluralize}/#{self.id}",
      mensaje: nil,
      tipo: "DELETE"
    )

    SyncronizeJob.perform_later
  end

  def to_sync_json
    self.to_json
  end
end

module Sincronizador
  extend ActiveSupport::Concern

  def syncronize_create
    Sincronizacion.create(
      path: self.class.to_s.downcase.pluralize,
      mensaje: self.to_sync_json,
      tipo: "POST"
    )

    syncronize
  end

  def syncronize_update
    Sincronizacion.create(
      path: "#{self.class.to_s.downcase.pluralize}/#{self.id}",
      mensaje: self.to_sync_json,
      tipo: "PATCH"
    )

    syncronize
  end

  def syncronize_destroy
    Sincronizacion.create(
      path: "#{self.class.to_s.downcase.pluralize}/#{self.id}",
      mensaje: nil,
      tipo: "DELETE"
    )

    syncronize
  end

  def to_sync_json
    self.to_json
  end

  def syncronize
    return unless Rails.application.config.x.sync

    SyncronizeJob.perform_later
  end
end

module Sincronizador
  extend ActiveSupport::Concern

  def syncronize_create
    Sincronizacion.create(
      path: self.class.to_s.downcase.pluralize,
      mensaje: self.to_sync_json,
      tipo: "POST"
    )

    SyncronizeJob.perform_later
  end

  def syncronize_update
    Sincronizacion.create(
      path: "#{self.class.to_s.downcase.pluralize}/#{self.id}",
      mensaje: self.to_sync_json,
      tipo: "PATCH"
    )

    SyncronizeJob.perform_later
  end

  def syncronize_destroy
    Sincronizacion.create(
      path: "#{self.class.to_s.downcase.pluralize}/#{self.id}",
      mensaje: self.to_sync_json,
      tipo: "DELETE"
    )

    SyncronizeJob.perform_later
  end

  def to_sync_json
    self.to_json
  end
end

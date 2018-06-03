module Syncronize
  extend ActiveSupport::Concern

  def syncronize_create
    Sincronizacion.create(
      path: self.class.to_s.downcase.pluralize,
      mensaje: self.to_json,
      tipo: "POST"
    )

    SyncronizeJob.perform_later
  end

  def syncronize_update
    Sincronizacion.create(
      path: "#{self.class.to_s.downcase.pluralize}/#{self.id}",
      mensaje: self.to_json,
      tipo: "PATCH"
    )

    SyncronizeJob.perform_later
  end

  def syncronize_delete
    Sincronizacion.create(
      path: "#{self.class.to_s.downcase.pluralize}/#{self.id}",
      mensaje: self.to_json,
      tipo: "DELETE"
    )

    SyncronizeJob.perform_later
  end
end

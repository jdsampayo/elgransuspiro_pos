module Syncronize
  extend ActiveSupport::Concern

  def syncronize_create(includes = {})
    Sincronizacion.create(
      path: self.class.to_s.downcase.pluralize,
      mensaje: self.to_json(includes),
      tipo: "POST"
    )

    SyncronizeJob.perform_later
  end

  def syncronize_update(includes = {})
    Sincronizacion.create(
      path: "#{self.class.to_s.downcase.pluralize}/#{self.id}",
      mensaje: self.to_json(includes),
      tipo: "PATCH"
    )

    SyncronizeJob.perform_later
  end

  def syncronize_delete(includes = {})
    Sincronizacion.create(
      path: "#{self.class.to_s.downcase.pluralize}/#{self.id}",
      mensaje: self.to_json(includes),
      tipo: "DELETE"
    )

    SyncronizeJob.perform_later
  end
end

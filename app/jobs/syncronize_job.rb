class SyncronizeJob < ApplicationJob
  queue_as :default

  BASE_URL = Rails.application.config.x.matriz_base_url

  def perform
    return if BASE_URL.blank?

    Sincronizacion.order(created_at: :asc).where(exito: false).each do |sincronizacion|
      json = sincronizacion.mensaje.present? ? JSON.parse(sincronizacion.mensaje) : nil
      url = "#{BASE_URL}#{sincronizacion.path}"
      connection = HTTP.headers(token: 'auth')

      resultado =
        case sincronizacion.tipo
        when 'POST'
          connection.post(url, json: json)
        when 'PATCH'
          connection.patch(url, json: json)
        when 'DELETE'
          connection.delete(url)
        else
          raise 'Not supported'
        end

      if resultado.code == 200 || resultado.code == 201 || resultado.code == 202 || resultado.code == 204
        sincronizacion.update(exito: true, webhooked_at: Time.current)
      elsif resultado.code == 409
        sincronizacion.update(
          exito: true,
          error: JSON.parse(resultado.body.to_s)['message'],
          webhooked_at: Time.current
        )
      else
        sincronizacion.update(
          error: JSON.parse(resultado.body.to_s)['message'],
          webhooked_at: Time.current
        )
      end
    end
  end
end

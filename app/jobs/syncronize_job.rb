class SyncronizeJob < ApplicationJob
  queue_as :default

  BASE_URL = ENV['MATRIZ_BASE_URL']

  def perform
    Sincronizacion.where(exito: false).each do |sincronizacion|
      json = JSON.parse(sincronizacion.mensaje)
      url = "#{BASE_URL}#{sincronizacion.path}"
      connection = HTTP.headers(token: "auth")

      resultado =
        case sincronizacion.tipo
        when 'POST'
          connection.post(url, json: json)
        when 'PATCH'
          connection.patch(url, json: json)
        when 'DELETE'
          connection.delete(url, json: json)
        else
          raise 'Not supported'
        end

      if resultado.code == 200
        sincronizacion.update(exito: true, webhooked_at: Time.current)
      elsif resultado.code == 409
        sincronizacion.update(
          exito: true,
          error: JSON.parse(resultado.body.to_s)["message"],
          webhooked_at: Time.current
        )
      else
        sincronizacion.update(
          error: JSON.parse(resultado.body.to_s)["message"],
          webhooked_at: Time.current
        )
      end
    end
  end
end

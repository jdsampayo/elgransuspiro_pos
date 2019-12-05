namespace :database_maintenance do
  desc "Tasks for maintenance of the database"

  task populate_pago_con_tarjeta: :environment do
    Comanda.where(es_pago_con_tarjeta: true).update_all('pago_con_tarjeta = venta')
    Comanda.where(es_pago_con_tarjeta: false).update_all('pago_con_efectivo = venta')
  end
end

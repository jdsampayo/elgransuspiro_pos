namespace :one_time do
  desc "Generate all UUIDS for previous records"
  task generate_all_uuids: :environment do
    #Articulo.all.each do |obj| obj.uuid = SecureRandom.uuid; obj.save; end
    #Mesero.all.each do |obj| obj.uuid = SecureRandom.uuid; obj.save; end
    #Comanda.all.each do |obj| obj.uuid = SecureRandom.uuid; obj.save; end
    #Orden.all.each do |obj| obj.uuid = SecureRandom.uuid; obj.save; end
    #Extra.all.each do |obj| obj.uuid = SecureRandom.uuid; obj.save; end
    #ExtraOrden.all.each do |obj| obj.uuid = SecureRandom.uuid; obj.save; end
    #Corte.all.each do |obj| obj.uuid = SecureRandom.uuid; obj.save; end
    #Gasto.all.each do |obj| obj.uuid = SecureRandom.uuid; obj.save; end
    #Categoria.all.each do |obj| obj.uuid = SecureRandom.uuid; obj.save; end
    #Conteo.all.each do |obj| obj.uuid = SecureRandom.uuid; obj.save; end
    #Desechable.all.each do |obj| obj.uuid = SecureRandom.uuid; obj.save; end
    ArticuloDesechable.all.each do |obj| obj.uuid = SecureRandom.uuid; obj.save; end
    #Plutus::Account.all.each do |obj| obj.uuid = SecureRandom.uuid; obj.save; end
    #Plutus::Entry.all.each do |obj| obj.uuid = SecureRandom.uuid; obj.save; end
    #Plutus::Amount.all.each do |obj| obj.uuid = SecureRandom.uuid; obj.save; end
    #Usuario.all.each do |obj| obj.uuid = SecureRandom.uuid; obj.save; end
    #Asistencia.all.each do |obj| obj.uuid = SecureRandom.uuid; obj.save; end
  end

  desc "Generate all Folios for comandas"
  task generate_folios: :environment do
    Sucursal.all.each do |sucursal|
      sucursal.comandas.all.order(:created_at).each do |comanda|
        comanda.set_folio
        comanda.save
      end
    end
  end

end

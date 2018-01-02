class Cuenta
  include ActiveModel::Model

  TIPOS = {
    asset: "Activo",
    liability: "Pasivo",
    equity: "Patrimonio",
    revenue: "Ingreso",
    expense: "Egreso"
  }

  attr_accessor(
    :nombre,
    :tipo,
    :contra
  )

  validates :nombre, presence: true
  validates :tipo, presence: true

  def self.plutus_a_tipo(plutus)
    TIPOS[plutus.type.split(":").last.downcase.to_sym]
  end

  def create
    if valid?
      plutus = "Plutus::#{tipo.titleize}".constantize.new(name: nombre, contra: contra)
      plutus.save

      # Map plutus errors to Contable
      plutus.errors.each do |atributo, mensaje|
        atributo = :nombre if atributo == :name
        atributo = :tipo if atributo == :type
        errors.add(atributo, mensaje)
      end
    end
    self
  end

end

require 'csv'

class Cuenta
  include ActiveModel::Model

  TIPOS = {
    asset: "Activo",
    liability: "Pasivo",
    equity: "Patrimonio",
    revenue: "Ingreso",
    expense: "Egreso"
  }

  ACCOUNTS = {
    "Banco" => :asset,
    "Caja Chica" => :asset,
    "Caja Fuerte" => :asset,
    "Capital Jorge" => :equity,
    "Capital Zuiry" => :equity,
    "Compra de Insumos" => :expense,
    "Tarjeta Crédito Cotsco" => :liability,
    "Cursos" => :expense,
    "Desechables" => :expense,
    "Egreso sin Categorizar" => :expense,
    "Electricidad" => :expense,
    "Gastos de Administración" => :expense,
    "Gastos de Operación" => :expense,
    "Ingreso sin Categorizar" => :revenue,
    "Loza y Utensilios" => :asset,
    "Maquinaria y Equipo" => :asset,
    "Panadería" => :expense,
    "Préstamos" => :liability,
    "Publicidad" => :expense,
    "Renta" => :expense,
    "Reparaciones y Mantenimiento" => :expense,
    "Sueldos" => :expense,
    "Teléfono e Internet" => :expense,
    "Transportación" => :expense,
    "Uniformes" => :expense,
    "Venta a Granel" => :revenue,
    "Ventas" => :revenue
  }

  WAVES_ACCOUNTS = {
    "Ventas de Alimentos y Bebidas" => "Ventas",
    "Cash on Hand" => "Caja Fuerte",
    "Zuiry Inversión / Retiros" => "Capital Zuiry",
    "Jorge Inversión / Retiros" => "Capital Jorge",
    "Machinery, equipment, furniture & fixtures" => "Maquinaria y Equipo",
    "Renta de Local" => "Renta",
    "Accounts Payable" => "Tarjeta Crédito Cotsco",
    "Nómina - Salarios y Sueldos" => "Sueldos",
    "Utensilios de cocina y loza" => "Loza y Utensilios",
    "Cursos y Capacitación" => "Cursos",
    "Publicidad y Promoción" => "Publicidad",
    "Compra de Insumos" => "Compra de Insumos",
    "Préstamos" => "Préstamos",
    "Reparaciones y Mantenimiento" => "Reparaciones y Mantenimiento",
    "Desechables" => "Desechables",
    "Gastos de Transportación" => "Transportación",
    "Consumo de Electricidad" => "Electricidad",
    "Uncategorized Income" => "Ingreso sin Categorizar",
    "Teléfono Fijo e Internet" => "Teléfono e Internet",
    "Uniformes" => "Uniformes",
    "Uncategorized Expense" => "Egreso sin Categorizar",
    "Payroll - Employee Expenses Paid" => "Egreso sin Categorizar",
    "Payroll – Employee Benefits" => "Egreso sin Categorizar",
    "Productos de Limpieza" => "Reparaciones y Mantenimiento",
    "Panadería" => "Panadería",
    "Café en grano" => "Venta a Granel",
    "Venta de productos a granel" => "Venta a Granel",
    "Cuenta Bancaria" => "Banco",
    "Trámites Legales" => "Gastos de Administración",
    "Printing and Reproduction" => "Publicidad",
    "Fumigador" => "Reparaciones y Mantenimiento",
    "Caja Fuerte" => "Caja Fuerte",
    "Tarjeta Cotsco" => "Tarjeta Crédito Cotsco"
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

  def self.seed_accounts
    Plutus::Account.delete_all

    ACCOUNTS.each do |name, type|
      plutus = "Plutus::#{type.to_s.titleize}".constantize.new(name: name, contra: false)
      plutus.save
    end
  end

  def self.load_waves_entries
    csv_text = File.read('tmp/transactions.csv')
    csv = CSV.parse(csv_text, headers: true)

    # invoice_num
    # account
    # debit_amount
    # credit_amount
    # currency
    # transaction_date
    accounts = csv.map do |row|
      row[1]
    end

    debit_amounts = csv.map do |row|
      row[2] ? {account: WAVES_ACCOUNTS[row[1]], amount: row[2], date: row[5], debit: true} : nil
    end.compact

    credit_amounts = csv.map do |row|
      row[3] ? {account: WAVES_ACCOUNTS[row[1]], amount: row[3], date: row[5], debit: false} : nil
    end.compact

    dates = (debit_amounts + credit_amounts).group_by do |amount|
      amount[:date]
    end

    dates.each do |date, entries|
      debits = []
      credits = []

      entries.each do |entry|
        if entry[:debit]
          debits << {account_name: entry[:account], amount: entry[:amount]}
        else
          credits << {account_name: entry[:account], amount: entry[:amount]}
        end
      end

      entry = Plutus::Entry.new(
        description: "Movimientos del día #{date}",
        date: date,
        debits: debits,
        credits: credits
      )
      entry.save
    end
  end

end

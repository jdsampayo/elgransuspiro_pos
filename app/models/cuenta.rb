require 'csv'

class Cuenta
  include ActiveModel::Model

  EPOCH = "2010-01-01".freeze

  TIPOS = {
    asset: 'Activo',
    liability: 'Pasivo',
    equity: 'Patrimonio',
    revenue: 'Ingreso',
    expense: 'Egreso'
  }.freeze

  COLORS = {
    'Plutus::Asset' => 'success',
    'Plutus::Liability' => 'danger',
    'Plutus::Revenue' => 'primary',
    'Plutus::Expense' => 'warning',
    'Plutus::Equity' => 'info'
  }.freeze

  ACCOUNTS = {
    'Agua' => :expense,
    'Banco' => :asset,
    'Café en Verde' => :expense,
    'Caja Chica' => :asset,
    'Caja Fuerte' => :asset,
    'Capital Jorge' => :equity,
    'Capital Zuiry' => :equity,
    'Compra de Insumos' => :expense,
    'Comisiones' => :expense,
    'Cursos' => :expense,
    'Desechables' => :expense,
    'Egreso sin Categorizar' => :expense,
    'Electricidad' => :expense,
    'Gastos de Administración' => :expense,
    'Gastos de Operación' => :expense,
    'Ingreso sin Categorizar' => :revenue,
    'Loza y Utensilios' => :asset,
    'Mantenimiento' => :expense,
    'Maquinaria y Equipo' => :asset,
    'Panadería' => :expense,
    'Préstamos' => :liability,
    'Publicidad' => :expense,
    'Renta' => :expense,
    'Reparaciones y Mantenimiento' => :expense,
    'Sueldos' => :expense,
    'Tarjeta Crédito' => :liability,
    'Té y Tisana' => :expense,
    'Teléfono e Internet' => :expense,
    'Transporte y Gasolina' => :expense,
    'Tueste' => :expense,
    'Uniformes' => :expense,
    'Venta a Granel' => :revenue,
    'Ventas' => :revenue
  }

  WAVES_ACCOUNTS = {
    'Ventas de Alimentos y Bebidas' => 'Ventas',
    'Cash on Hand' => 'Caja Fuerte',
    'Zuiry Inversión / Retiros' => 'Capital Zuiry',
    'Jorge Inversión / Retiros' => 'Capital Jorge',
    'Machinery, equipment, furniture & fixtures' => 'Maquinaria y Equipo',
    'Renta de Local' => 'Renta',
    'Accounts Payable' => 'Tarjeta Crédito',
    'Nómina - Salarios y Sueldos' => 'Sueldos',
    'Utensilios de cocina y loza' => 'Loza y Utensilios',
    'Cursos y Capacitación' => 'Cursos',
    'Publicidad y Promoción' => 'Publicidad',
    'Compra de Insumos' => 'Compra de Insumos',
    'Préstamos' => 'Préstamos',
    'Reparaciones y Mantenimiento' => 'Reparaciones y Mantenimiento',
    'Desechables' => 'Desechables',
    'Gastos de Transportación' => 'Transportación',
    'Consumo de Electricidad' => 'Electricidad',
    'Uncategorized Income' => 'Ingreso sin Categorizar',
    'Teléfono Fijo e Internet' => 'Teléfono e Internet',
    'Uniformes' => 'Uniformes',
    'Uncategorized Expense' => 'Egreso sin Categorizar',
    'Payroll - Employee Expenses Paid' => 'Egreso sin Categorizar',
    'Payroll - Employee Benefits' => 'Egreso sin Categorizar',
    'Productos de Limpieza' => 'Reparaciones y Mantenimiento',
    'Panadería' => 'Panadería',
    'Café en grano' => 'Venta a Granel',
    'Venta de productos a granel' => 'Venta a Granel',
    'Cuenta Bancaria' => 'Banco',
    'Trámites Legales' => 'Gastos de Administración',
    'Printing and Reproduction' => 'Publicidad',
    'Fumigador' => 'Reparaciones y Mantenimiento',
    'Caja Fuerte' => 'Caja Fuerte',
    'Tarjeta Cotsco' => 'Tarjeta Crédito'
  }

  attr_accessor(
    :nombre,
    :tipo,
    :contra
  )

  validates :nombre, presence: true
  validates :tipo, presence: true

  def self.options_for_select
    Plutus::Account.select(:id, :name, :type).group_by(&:type).map do |k,v|
      [plutus_a_tipo(k), v.pluck(:name, :id)]
    end
  end

  def self.plutus_a_tipo(plutus_type)
    TIPOS[plutus_type.split(":").last.downcase.to_sym]
  end

  def self.caja_chica
    Plutus::Account.where(name: 'Caja Chica').take
  end

  def self.caja_fuerte
    Plutus::Account.where(name: 'Caja Fuerte').take
  end

  def self.banco
    Plutus::Account.where(name: 'Banco').take
  end

  def self.cash
      [caja_chica, caja_fuerte, banco]
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
    seed_accounts
    Plutus::Entry.delete_all
    Plutus::Amount.delete_all

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
      row[2] ? {account: get_waves_account(row[1]), amount: row[2], date: row[5], debit: true} : nil
    end.compact

    credit_amounts = csv.map do |row|
      row[3] ? {account: get_waves_account(row[1]), amount: row[3], date: row[5], debit: false} : nil
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

  def self.get_waves_account(name)
    account = WAVES_ACCOUNTS[name]
    raise "No se encontró: '#{name}'" if account.nil?

    account
  end

end

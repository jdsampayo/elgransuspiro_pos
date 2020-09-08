class Entrada
  include ActiveModel::Model

  validates :description, presence: true
  validates :date, presence: true
  validates :debits_attributes, presence: true
  validates :credits_attributes, presence: true

  attr_accessor(
    :description,
    :image,
    :date,
    :debits_attributes,
    :credits_attributes
  )

  def self.plutus_id(name)
    Plutus::Account.find_by(name: name).id
  end

  SHORTCUTS = {
    plain: {
      description: 'Movimientos del día',
      debits: [
        plutus_id('Gastos de Administración')
      ],
      credits: [
        plutus_id('Caja Fuerte')
      ]      
    },
    costco: {
      description: 'Compra de Insumos Costco/Sams/Walmart',
      debits: [
        plutus_id('Compra de Insumos')
      ],
      credits: [
        plutus_id('Tarjeta de Crédito'),
        plutus_id('Caja Fuerte'),
        plutus_id('Banco')
      ]
    },
    coffee: {
      description: 'Compra de Café en Verde/Tueste',
      debits: [
        plutus_id('Café en Verde'),
        plutus_id('Tueste')
      ],
      credits: [
        plutus_id('Banco'),
        plutus_id('Caja Fuerte')
      ]
    },
    etrusca: {
      description: 'Compra de Insumos Etrusca',
      debits: [
        plutus_id('Té y Tisana')
      ],
      credits: [
        plutus_id('Banco'),
        plutus_id('Caja Fuerte')
      ]
    },
    electricity: {
      description: 'Electricidad',
      debits: [
        plutus_id('Electricidad')
      ],
      credits: [
        plutus_id('Tarjeta de Crédito')
      ]
    },
    internet: {
      description: 'Teléfono e Internet',
      debits: [
        plutus_id('Teléfono e Internet')
      ],
      credits: [
        plutus_id('Tarjeta de Crédito')
      ]
    },
    rent: {
      description: 'Renta',
      debits: [
        plutus_id('Renta')
      ],
      credits: [
        plutus_id('Caja Fuerte')
      ]
    },
    water: {
      description: 'Agua',
      debits: [
        plutus_id('Agua')
      ],
      credits: [
        plutus_id('Caja Fuerte')
      ]
    },
    payroll: {
      description: 'Sueldos',
      debits: [
        plutus_id('Sueldos')
      ],
      credits: [
        plutus_id('Caja Fuerte')
      ]
    },
    maintenance: {
      description: 'Mantenimiento',
      debits: [
        plutus_id('Mantenimiento')
      ],
      credits: [
        plutus_id('Caja Fuerte')
      ]
    }

  }

  def plutus_name(account_id)
    Plutus::Account.find(account_id).name
  end

  def plutus_params(movement)
    {
      account_name: plutus_name(movement[:account_id]),
      amount: movement[:amount].to_f
    }
  end

  def save
    return unless valid?

    debits = debits_attributes.values.map do |movement|
      plutus_params(movement)
    end

    credits = credits_attributes.values.map do |movement|
      plutus_params(movement)
    end

    entry = Plutus::Entry.new(
      description: description,
      date: date,
      debits: debits,
      credits: credits
    )

    if entry.save
      return true
    else
      @errors = entry.errors
      return false
    end
  end
end

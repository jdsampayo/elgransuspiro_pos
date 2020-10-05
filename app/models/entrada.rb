class Entrada
  include ActiveModel::Model

  validates :description, presence: true
  validates :date, presence: true
  validates :debits_attributes, presence: true
  validates :credits_attributes, presence: true

  attr_accessor(
    :id,
    :description,
    :image,
    :date,
    :debits_attributes,
    :credits_attributes,
    :persisted,
    :errored
  )

  def self.plutus_id(name)
    Plutus::Account.find_by(name: name).id
  rescue
    puts "Can't find account #{name}"
    nil
  end

  def persisted?
    persisted
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
    },
    gas: {
      description: 'Transporte y Gasolina',
      debits: [
        plutus_id('Transporte y Gasolina')
      ],
      credits: [
        plutus_id('Caja Fuerte'),
        plutus_id('Tarjeta de Crédito')
      ]
    },
    disposable: {
      description: 'Desechables',
      debits: [
        plutus_id('Desechables')
      ],
      credits: [
        plutus_id('Tarjeta de Crédito')
      ]
    },
    crockery: {
      description: 'Loza y Utensilios',
      debits: [
        plutus_id('Loza y Utensilios')
      ],
      credits: [
        plutus_id('Tarjeta de Crédito'),
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

  def self.find(id)
    plutus_entry = Plutus::Entry.find(id)

    entrada = Entrada.new
    entrada.description = plutus_entry.description
    entrada.date = plutus_entry.date
    entrada.id = plutus_entry.id
    entrada.persisted = true

    entrada
  end

  def update(params)
    plutus_entry = Plutus::Entry.find(id)

    return unless plutus_entry

    plutus_entry.description = params[:description]
    plutus_entry.date = params[:date]

    plutus_entry.save
  end

  def delete
    plutus_entry = Plutus::Entry.find(id)

    return unless plutus_entry

    plutus_entry.delete
    Plutus::Amount.where(entry_id: id).delete_all
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

    entry.save
  end
end

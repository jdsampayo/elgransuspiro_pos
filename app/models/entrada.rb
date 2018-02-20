class Entrada
  include ActiveModel::Model

  validates :description, presence: true
  validates :date, presence: true
  validates :debits_attributes, presence: true
  validates :credits_attributes, presence: true

  attr_accessor(
    :description,
    :date,
    :debits_attributes,
    :credits_attributes
  )

  def registro_contable
    debits = debits_attributes.values.map do |debit|
      {account_name: Plutus::Account.find(debit[:account_id]).name, amount: debit[:amount].to_f}
    end
    credits = credits_attributes.values.map do |credit|
      {account_name: Plutus::Account.find(credit[:account_id]).name, amount: credit[:amount].to_f}
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
      return false, entry.errors.full_messages.join("\n")
    end
  end
end

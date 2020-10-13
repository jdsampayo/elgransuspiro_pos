# frozen_string_literal: true

require 'extensions/plutus'

Rails.application.config.to_prepare do
  begin
    if ActiveRecord::Base.connection.table_exists?(:plutus_entries)
      Plutus::Entry.include Extensions::PlutusEntry
      Plutus::DebitAmount.include Extensions::PlutusAmount
      Plutus::CreditAmount.include Extensions::PlutusAmount
      Plutus::Account.include Extensions::PlutusAccount
    end
  rescue ActiveRecord::NoDatabaseError
  end
end

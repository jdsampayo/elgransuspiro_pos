# frozen_string_literal: true

require 'extensions/plutus'

Rails.application.config.to_prepare do
  begin
    if ActiveRecord::Base.connection.table_exists?(:plutus_entries)
      Plutus::Entry.include Extensions::Plutus
    end
  rescue ActiveRecord::NoDatabaseError
  end
end

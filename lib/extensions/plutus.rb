# lib/extensions/gutentag.rb
# frozen_string_literal: true

module Extensions
  module Plutus
    extend ActiveSupport::Concern
    
    included do
      has_many :amounts, class_name: 'Plutus::Amount', inverse_of: :entry
      has_many :accounts, through: :amounts, source: :account, class_name: 'Plutus::Account'

      scope :with_account, ->(account) {
        where('plutus_accounts.id' => account) if account.present?
      }
      scope :with_description, ->(description) {
        where("description like ?", "%#{description}%") if description.present?
      }
    end
  end
end

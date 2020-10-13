# frozen_string_literal: true

module Extensions
  module PlutusEntry
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

  module PlutusAmount
    extend ActiveSupport::Concern

    class_methods do
      def balance_by_month_and_account(year)
        accounts = Plutus::Account.all

        data = includes(:entry, :account).group(:account_id, :type, :contra).group_by_month(
          :date,
          range: year.beginning_of_year..year.end_of_year,
          time_zone: 'UTC'
        ).sum(:amount)

        data.inject({}) do |balances, (k, v)|
          balances[k[0]] ||= {}
          balances[k[0]][k[3]] ||= 0

          contra_value = k[2] ? -v : v

          credit_balance = accounts.find { |a| a.id == k[0] }.normal_credit_balance
          if credit_balance ^ k[2]
            if k[1] == "Plutus::CreditAmount"
              balances[k[0]][k[3]] += v
            else
              balances[k[0]][k[3]] -= v
            end
          else
            if k[1] == "Plutus::DebitAmount"
              balances[k[0]][k[3]] += v
            else
              balances[k[0]][k[3]] -= v
            end
          end

          balances
        end
      end
    end
  end

  module PlutusDebitCreditAmount
    extend ActiveSupport::Concern
    
    class_methods do
      def balance_by_month(year)
        includes(:entry).group_by_month(
          :date,
          range: year.beginning_of_year..year.end_of_year,
          time_zone: 'UTC'
        ).sum(:amount)
      end
    end
  end

  module PlutusAccount
    extend ActiveSupport::Concern

    def balance_by_month(year)
      if self.class == Plutus::Account
        raise(NoMethodError, "undefined method 'balance_by_month'")
      else
        if self.normal_credit_balance ^ contra
          debit_amounts.balance_by_month(year).merge(credit_amounts.balance_by_month(year)) { |_, a, b| b - a } 
        else
          debit_amounts.balance_by_month(year).merge(credit_amounts.balance_by_month(year)) { |_, a, b| a - b } 
        end
      end
    end

    class_methods do
      def balance_by_month(year)
        if self.new.class == Plutus::Account
          raise(NoMethodError, "undefined method 'balance_by_month'")
        else
          accounts_balance = {}
          accounts = self.all
          accounts.each do |account|
            if account.contra
              accounts_balance.merge!(account.balance_by_month(year)) { |_, a, b| a - b }
            else
              accounts_balance.merge!(account.balance_by_month(year)) { |_, a, b| a + b }
            end
          end
          accounts_balance
        end
      end
    end
  end
end

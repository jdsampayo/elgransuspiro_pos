module Contabilidad
  module ReportesHelper
    def link_to_balance balance, month, account
      link_to(
        balance.round(2),
        contabilidad_entradas_path(
          limit: 300,
          order: 'descendente',
          start: month,
          end: month.end_of_month,
          account_id: account.id
        )
      )
    end
  end
end

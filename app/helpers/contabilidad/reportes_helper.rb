module Contabilidad
  module ReportesHelper
    def link_to_balance text, month, account, options=nil
      link_to(
        text.to_s.html_safe,
        contabilidad_entradas_path(
          limit: 300,
          order: 'descendente',
          start: month,
          end: month.end_of_month,
          account_id: account.id
        ),
        options
      )
    end

    def link_to_account balance, month, account
      link_to(
        balance.round(2),
        contabilidad_cuenta_path(
          account,
          start: month,
          end: month.end_of_month
        )
      )
    end
  end
end

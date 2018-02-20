ActiveSupport::Inflector.inflections do |inflect|
  inflect.plural(/$/, 's')
  inflect.plural(/([^aeéiou])$/i, '\1es')
  inflect.plural(/([aeiou]s)$/i, '\1')
  inflect.plural(/z$/i, 'ces')
  inflect.plural(/á([sn])$/i, 'a\1es')
  inflect.plural(/é([sn])$/i, 'e\1es')
  inflect.plural(/í([sn])$/i, 'i\1es')
  inflect.plural(/ó([sn])$/i, 'o\1es')
  inflect.plural(/ú([sn])$/i, 'u\1es')

  inflect.singular(/s$/, '')
  inflect.singular(/es$/, '')

  inflect.irregular('corte', 'cortes')
  inflect.irregular('desechable', 'desechables')
  inflect.irregular('contable', 'contables')

  # Plutus
  inflect.irregular('account', 'accounts')
  inflect.irregular('entry', 'entries')
  inflect.irregular('amount', 'amounts')
  inflect.irregular('report', 'reports')
  inflect.irregular('credit', 'credits')
  inflect.irregular('debit', 'debits')

  # Se agregan inflectores para todos los casos de detalle_ y detalles_
  # Ejs.:
  # detalle_pendiente_aprobacion -> detalles_pediente_aprobacion
  # detalle_rechazo -> detalles_rechazo
  inflect.plural /(\bdetalle)(\w+|_|$)/, '\1s\2'
  inflect.plural /(\bdetalles)(\w+|_|$)/, '\1\2'
  inflect.singular /(\bdetalle)s(\w+|_|$)/, '\1\2'
end

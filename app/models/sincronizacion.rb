# == Schema Information
#
# Table name: sincronizaciones
#
#  id           :uuid             not null, primary key
#  mensaje      :text
#  path         :string
#  tipo         :string
#  webhooked_at :datetime
#  error        :text
#  exito        :boolean          default(FALSE)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Sincronizacion < ApplicationRecord
end

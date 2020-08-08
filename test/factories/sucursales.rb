# == Schema Information
#
# Table name: sucursales
#
#  id         :uuid             not null, primary key
#  nombre     :string
#  direccion  :text
#  telefono   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :sucursal do
    nombre { "MyString" }
    direccion { "MyText" }
    telefono { "MyString" }
  end
end

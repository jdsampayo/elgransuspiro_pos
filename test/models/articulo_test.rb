# == Schema Information
#
# Table name: articulos
#
#  id           :uuid             not null, primary key
#  nombre       :text
#  precio       :decimal(, )      default(0.0)
#  created_at   :datetime
#  updated_at   :datetime
#  categoria_id :uuid
#  deleted_at   :datetime
#

require 'test_helper'

class ArticuloTest < ActiveSupport::TestCase
  test 'articulo should include desechable ids when is serialized' do
    articulo = create(:articulo)
    articulo.desechables << create(:desechable, :tapa)
    articulo.desechables << create(:desechable, :vaso)
    articulo.save

    desechables = articulo.desechables

    assert_not_empty(desechables)
    assert_equal(
      JSON.parse(articulo.to_sync_json)['articulo']['desechable_ids'],
      desechables.pluck(:id)
    )
  end
end

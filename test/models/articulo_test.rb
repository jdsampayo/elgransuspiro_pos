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
  # test "the truth" do
  #   assert true
  # end
end

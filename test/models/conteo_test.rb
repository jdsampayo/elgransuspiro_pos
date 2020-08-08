# == Schema Information
#
# Table name: conteos
#
#  id          :uuid             not null, primary key
#  articulo_id :uuid
#  corte_id    :uuid
#  total       :bigint           default(0)
#  deleted_at  :datetime
#

require 'test_helper'

class ConteoTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

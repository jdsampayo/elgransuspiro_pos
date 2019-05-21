# == Schema Information
#
# Table name: extra_ordenes
#
#  id         :uuid             not null, primary key
#  extra_id   :uuid
#  orden_id   :uuid
#  created_at :datetime
#  updated_at :datetime
#  deleted_at :datetime
#

require 'test_helper'

class ExtraOrdenTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

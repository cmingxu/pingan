# == Schema Information
#
# Table name: patients
#
#  id         :integer          not null, primary key
#  account_id :integer
#  name       :string
#  phone      :string
#  age        :integer
#  month      :integer
#  gender     :string
#  entroll_at :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class PatientTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

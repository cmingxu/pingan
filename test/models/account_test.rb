# == Schema Information
#
# Table name: accounts
#
#  id         :integer          not null, primary key
#  username   :string
#  password   :string
#  user_agent :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class AccountTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

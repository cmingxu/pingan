# == Schema Information
#
# Table name: accounts
#
#  id               :integer          not null, primary key
#  username         :string
#  password         :string
#  user_agent       :string
#  proxy            :string
#  proxy_renew_at   :datetime
#  proxy_last_ok_at :datetime
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'test_helper'

class AccountTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

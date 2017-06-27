# == Schema Information
#
# Table name: logins
#
#  id         :integer          not null, primary key
#  ip         :string
#  account_id :integer
#  status     :string
#  login_at   :datetime
#  exception  :text
#  proxy      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Login < ApplicationRecord
  belongs_to :account

  scope :today, -> { where("login_at > ? AND login_at < ?", Time.now.beginning_of_day, Time.now.end_of_day) }
  scope :done, -> { where("status = 'done'") }

end

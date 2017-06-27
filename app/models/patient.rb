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

class Patient < ApplicationRecord
  belongs_to :account
  validates :name, :phone, :age, :month, :gender, presence: true

  scope :today, -> { where("login_at > ? AND login_at < ?", Time.now.beginning_of_day, Time.now.end_of_day) }
end

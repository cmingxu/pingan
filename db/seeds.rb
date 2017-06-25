require 'random_user_agent'

%w(13074792899 13234773388 18647324887 13847332106).each do |username|
  Account.create username: username, password: "Wanjia4657", user_agent: RandomUserAgent.randomize
end

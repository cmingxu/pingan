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

class Account < ApplicationRecord
  LOGIN_PAGE = "https://passport.pinganwj.com/login?targetType=wanjiaB_SZ&service=https%3A%2F%2Fmyclinic.pinganwj.com%2F"
  CLINIC_PAGE = "https://myclinic.pinganwj.com/"
  CHROME_SWITCHES = %w(--ignore-certificate-errors --disable-popup-blocking --disable-translate)

  TEST_SITE = "https://www.baidu.com/"

  has_many :logins

  def self.time_fit?
    !(Time.now.hour < 8 || Time.now.hour > 20)
  end

  def login
    login = self.logins.build
    login.proxy = self.proxy
    login.status = "new"
    login.save
    begin
      switches = CHROME_SWITCHES.clone
      switches.push("--proxy-server=#{self.proxy}")
      browser = Watir::Browser.new :chrome, switches: switches
      browser.driver.manage.timeouts.implicit_wait = 10

      browser.goto LOGIN_PAGE
      puts browser.title

      toggleDiv = browser.div(class: 'tab js_exchange_login_meth')
      toggleDiv.click

      username_field = browser.text_field id: 'username'
      username_field.set self.username

      password_field = browser.text_field class: 'password'
      puts password_field.exists?
      password_field.set self.password

      submitLink = browser.link class: 'login-btn'
      puts submitLink.exists?
      submitLink.click

      #browser.goto CLINIC_PAGE


      #browser.li(id: "patient_management").click

      #browser.iframe(:index => 0).text_field(id: "patiName").set("foobar")
      #browser.iframe(:index => 0).text_field(id: "phone").set("foobar")

      browser.close
    rescue Exception => e
      login.status = "fail"
      login.exception = e.message
      login.save
      browser.close
      return
    end

    login.status = "done"
    login.login_at = Time.now
    login.save
  end

  def self.test_or_renew_proxy
    Account.find_each do |account|
      next if account.proxy_ok?

      account.new_proxy
      sleep 5
    end
  end

  include HTTParty

  def proxy_ok?
    return false if self.proxy.blank?

    opts = {
      http_proxyaddr: self.proxy.split(":")[0],
      http_proxyport:  self.proxy.split(":")[1],
      verify: false,
      timeout: 5
    }

    #resp = self.class.get("http://httpbin.org/ip", opts)
    begin
      resp = self.class.get(TEST_SITE, opts)
    rescue Exception => e
      puts "#{opts[:http_proxyaddr]}:#{opts[:http_proxyport]}  #{TEST_SITE} got exception"
      puts e
      return false
    end

    puts "testing got #{resp}"
    self.update_column :proxy_last_ok_at, Time.now
    resp.code.to_i == 200
  end

  def new_proxy
    proxies_api = "http://dev.kuaidaili.com/api/getproxy/?orderid=959836867801697&num=10&b_pcchrome=1&b_pcie=1&b_pcff=1&protocol=2&method=1&an_an=1&an_ha=1&sep=1"
    resp = HTTParty.get proxies_api
    new_proxies = resp.body.split("\n")
    new_proxies.each do |p|
      puts "test proxy #{p}"
      next if p == self.proxy
      self.proxy = p
      self.proxy_renew_at = Time.now
      if self.proxy_ok?
        puts "good proxy #{self.proxy}"
        self.save
        break
      end
    end
  end
end

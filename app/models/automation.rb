class Automation
  LOGIN_PAGE = "https://passport.pinganwj.com/login?targetType=wanjiaB_SZ&service=https%3A%2F%2Fmyclinic.pinganwj.com%2F"
  CHROME_SWITCHES = %w(--ignore-certificate-errors --disable-popup-blocking --disable-translate)

  def self.time_fit?
    !(Time.now.hour < 8 || Time.now.hour > 20)
  end

  def self.shuffle_account
    Account.all.shuffle.first
  end

  def self.login
    login = account.logins.build
    switches = CHROME_SWITCHES.clone
    switches.push("--proxy-server=49.82.248.132:33220")
    browser = Watir::Browser.new :chrome, switches: CHROME_SWITCHES
    browser.goto LOGIN_PAGE
    puts browser.title

    toggleDiv = browser.div(class: 'tab js_exchange_login_meth')
    toggleDiv.click

    username_field = browser.text_field id: 'username'
    username_field.set account.username

    password_field = browser.text_field class: 'password'
    puts password_field.exists?
    password_field.set account.password

    submitLink = browser.link class: 'login-btn'
    puts submitLink.exists?
    submitLink.click

    puts browser.title

    login.status = "done"
    login.save

  end
end


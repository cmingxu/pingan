class ProxyFetcher
  include HTTParty

  def self.fetch
    response = self.get "https://www.torvpn.com/en/proxy-list"
    puts response
  end
end

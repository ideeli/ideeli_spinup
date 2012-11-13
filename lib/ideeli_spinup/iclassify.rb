require 'iclassify-interface'

module IdeeliSpinup
module Classifiers
class IClassify
  def initialize (options)
    url = options[:url]
    username = options[:username]
    password = options[:password]
    @ic = ::IClassify::Client.new url, username, password
  end
  
  def exists? (hostname)
    nodes = @ic.search("fqdn:#{hostname}", %w[fqdn])
    !nodes.empty?
  end
end
end

end

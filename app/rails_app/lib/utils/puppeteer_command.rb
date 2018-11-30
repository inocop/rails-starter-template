require 'shellwords'

class PuppeteerCommand

  def self.hello_node(text="")
    return `timeout 5 node #{Rails.root}/lib/nodejs/hello.js #{Shellwords.escape(text)}`
  end
end

require 'shellwords'

class PuppeteerCommand

  def self.hello_node(text="")
    return `"timeout 5 node /var/my_dir/app/node_app/hello.js #{Shellwords.escape(text)}`
  end
end

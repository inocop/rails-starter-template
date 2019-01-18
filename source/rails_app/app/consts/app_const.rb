module AppConst

  APP_NAME = "Rails App"
  MAIL_FROM = "#{AppConst::APP_NAME}<#{Rails.application.config.x.myconf[:mail_from]}>"

  # chromiumのパス(puppeteerでインストールされるchromiumを指定)
  CHROMIUM_PATH = "/usr/lib/node_modules/puppeteer/.local-chromium/linux-575458/chrome-linux/chrome"
end
require 'shellwords'
require 'timeout'

class ChromiumCommand

  def initialize(width: 1366, height: 768)
    @width = width.to_i
    @height = height.to_i
  end

  # screenshot出力
  def html_to_png(html:, save_path:)
    begin
      Timeout.timeout(5) do
        system(*[AppConst::CHROMIUM_PATH,
                "--headless",
                "--disable-gpu",
                "--no-sandbox",
                "--window-size=#{@width},#{@height}",
                "--screenshot=#{Shellwords.escape(save_path)}",
                html])
      end
    rescue Timeout::Error
      false
    end
  end

  # pdf出力
  def html_to_pdf(html:, save_path:)
    begin
      Timeout.timeout(5) do
        system(*[AppConst::CHROMIUM_PATH,
                  "--headless",
                  "--disable-gpu",
                  "--no-sandbox",
                  "--window-size=#{@width},#{@height}",
                  "--print-to-pdf=#{Shellwords.escape(save_path)}",
                  html])
      end
    rescue Timeout::Error
      false
    end
  end

end

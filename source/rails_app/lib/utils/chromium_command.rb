require 'shellwords'

class ChromiumCommand

  def initialize(width: 1366, height: 768)
    @width = width.to_i
    @height = height.to_i
  end

  # screenshot出力
  # @params html [string] url or path/to/*.html
  # @params save_path [string] filepath
  #
  # @return [bool]
  def html_to_png(html:, save_path:)
      system(*[ "timeout",
                "5",
                AppConst::CHROMIUM_PATH,
                "--headless",
                "--disable-gpu",
                "--no-sandbox",
                "--window-size=#{@width},#{@height}",
                "--screenshot=#{Shellwords.escape(save_path)}",
                html])
  end

  # pdf出力
  # @params html [string] url or path/to/*.html
  # @params save_path [string] filepath
  #
  # @return [bool]
  def html_to_pdf(html:, save_path:)
    system(*[ "timeout",
              "5",
              AppConst::CHROMIUM_PATH,
              "--headless",
              "--disable-gpu",
              "--no-sandbox",
              "--window-size=#{@width},#{@height}",
              "--print-to-pdf=#{Shellwords.escape(save_path)}",
              html])
  end

end

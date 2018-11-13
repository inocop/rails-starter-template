require "test_helper"
require 'capybara/rails'
require 'selenium-webdriver'


class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  #driven_by :selenium, using: :chrome, screen_size: [1400, 1400]
  driven_by :headless_chromium

  # $ bundle exec chromedriver-update 2.42
  #   install to > ~/.chromedriver-helper
  Chromedriver.set_version "2.42"

  Capybara.register_driver :headless_chromium do |app|
    capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
      chromeOptions: {
        # npmのpuppeteerでインストールされるchromiumを指定
        binary: MyAppConst::CHROMIUM_PATH,
        args: %w(headless disable-gpu no-sandbox window-size=1366x768)
      }
    )
    Capybara::Selenium::Driver.new(
      app,
      browser: :chrome,
      desired_capabilities: capabilities
    )
  end

  Capybara.default_driver = :headless_chromium
  Capybara.javascript_driver = :headless_chromium
  Capybara.default_max_wait_time = 5


  def set_user_and_project(user:, project_id:)
    visit('/users/sign_in')

    if page.current_path == '/users/sign_in'
      fill_in('email',    :with => user.email)
      fill_in('password', :with => "password")
      click_button 'ログイン'
    end

    find("option[value='#{project_id}']").select_option if project_id
  end

  def wait_for_ajax
    Timeout.timeout(Capybara.default_max_wait_time) do
      loop do
        break if page.evaluate_script('jQuery.active').zero?
      end
    end
  end

  def wait_loading
    unless block_given?
      raise "There is no block"
    end

    10.times do
      result = yield
      if result.instance_of?(TrueClass)
        return
      else
        sleep(1)
      end
    end
    raise "wati timeover"
  end

  def get_cookie(name:)
    cookies = page.driver.browser.manage.all_cookies
    cookie = cookies.find { |c| c[:name] == name }
    cookie && cookie[:value]
  end

  def set_cookie(name:, value:)
    page.driver.browser.manage.add_cookie(name: name, value: value.to_s)
  end
end

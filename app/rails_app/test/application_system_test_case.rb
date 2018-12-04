require "test_helper"
require 'capybara/rails'
require 'selenium-webdriver'
require 'chromedriver-helper'

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
        binary: AppConst::CHROMIUM_PATH,
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


  def sign_in(user, project_id=nil)
    visit('/users/sign_in')

    if page.current_path == '/users/sign_in'
      page.fill_in('user[email]',    with: user.email)
      page.fill_in('user[password]', with: "password")
      page.click_button 'ログイン'
    end

    select_project(project_id) if project_id.present?
  end

  def select_project(project_id)
    #page.driver.submit(:post, "/api/select_project", {project_id: project_id})
    page.find("option[value='#{project_id}']").select_option
  end

  def get_cookie(name:)
    cookies = page.driver.browser.manage.all_cookies
    cookie = cookies.find { |c| c[:name] == name }
    cookie && cookie[:value]
  end

  def set_cookie(name:, value:)
    page.driver.browser.manage.add_cookie(name: name, value: value.to_s)
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
end

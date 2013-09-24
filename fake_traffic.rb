require 'rubygems'
require 'capybara'
require 'capybara/dsl'
require 'thor'

Capybara.run_server = false
Capybara.current_driver = :selenium
Capybara.app_host = 'localhost:3000'

module CapybaraTraffic
  class Dummy
    include Capybara::DSL

    def login
      unless page.has_link?("Logout")
        visit('/users/sign_in')
        fill_in "Email", with: "test@test.com"
        fill_in "Password", with: "password"
        click_button "Sign in"
        sleep 3
      end
    end

    def home
      visit('/')
      sleep 3
    end

    def view_widget
      login
      visit('/widgets')
      page.first(:link, "Show").click
      sleep 3
    end

    def create_widget
      login
      visit('/widgets')
      click_link "New Widget"
      fill_in "Name", with: "Dummy widget #{rand(500)}"
      click_button "Create Widget"
      sleep 3
    end

    def destroy_widget
      login
      visit('/widgets')
      page.first(:link, "Destroy").click
      page.driver.browser.switch_to.alert.accept
      sleep 3
    end

    def logout
      login
      visit('/widgets')
      click_link "Logout"
      sleep 3
    end
  end
end

class CLI < Thor
  @@browser = CapybaraTraffic::Dummy.new

  option :repeat, type: :numeric
  desc 'visit_home', 'visit the home page'
  def visit_home
    if options[:repeat]
      options[:repeat].times { @@browser.home }
    else
      @@browser.home
    end
  end

  option :repeat, type: :numeric
  desc 'login', 'login a user'
  def login
    if options[:repeat]
      options[:repeat].times do
        @@browser.login
        @@browser.logout
      end
    else
      @@browser.login
    end
  end

  option :repeat, type: :numeric
  desc 'logout', 'logout a user'
  def logout
    if options[:repeat]
      options[:repeat].times do
        @@browser.logout
      end
    else
      @@browser.logout
    end
  end

  option :repeat, type: :numeric
  desc 'view_widget', 'view a specific widget'
  def view_widget
    if options[:repeat]
      options[:repeat].times { @@browser.view_widget }
    else
      @@browser.view_widget
    end
  end

  option :repeat, type: :numeric
  desc 'create_widget', 'create a new widget'
  def create_widget
    if options[:repeat]
      options[:repeat].times { @@browser.create_widget }
    else
      @@browser.create_widget
    end
  end

  option :repeat, type: :numeric
  desc 'destroy_widget', 'destroy a widget'
  def destroy_widget
    if options[:repeat]
      options[:repeat].times { @@browser.destroy_widget }
    else
      @@browser.destroy_widget
    end
  end
end

CLI.start(ARGV)
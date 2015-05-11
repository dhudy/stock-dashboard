require 'rubygems'
require 'selenium/client'
require 'rspec'
require 'selenium-webdriver'

describe "Test", :type => :selenium do
	attr_reader :selenium_driver
	before(:each) do
		@selenium_driver = Selenium::WebDriver.for :firefox
		@wait = Selenium::WebDriver::Wait.new(:timeout => 30)

	end

	after(:each) do
		@selenium_driver.quit
	end

	def facebookLogin(userName, pw)
		@selenium_driver.navigate.to "https://nameless-ravine-8460.herokuapp.com/"
		@selenium_driver.find_element(:xpath, '//*[@id="page-wrapper"]/div/a[2]').click
		@wait.until {@selenium_driver.find_element(:class, 'uiHeaderTitle').displayed? }
		@selenium_driver.find_element(:id, 'email').send_keys(userName)
		@selenium_driver.find_element(:id, 'pass').send_keys(pw)
		@selenium_driver.find_element(:id, 'u_0_2').click
	end

	it "can reach the website" do
		@selenium_driver.navigate.to "https://nameless-ravine-8460.herokuapp.com/"
		expect(@selenium_driver.title).to eq("StockDashboard")
	end

	it "can find the homepage" do
		facebookLogin("djh3315@gmail.com", "Password404")
		expect(@selenium_driver.current_url).to eq("https://nameless-ravine-8460.herokuapp.com/welcome#_=_")
	end

	it "can look up stocks by code" do
		facebookLogin("djg3315@gmail.com", "Password404")
		@selenium_driver.find_element(:xpath, '//*[@id="lookup"]').send_keys("AAPL")
		@selenium_driver.find_element(:xpath, '//*[@id="side-menu"]/li[1]/form/div[2]/span/button').click
		expect(@selenium_driver.find_element(:xpath, '//*[@id="page-wrapper"]/div/div/div[2]/div/div[2]/ul/li[1]').text).to eq(":Apple Inc (AAPL)")
	end

	it "can buy a stock" do
		facebookLogin("djg3315@gmail.com", "Password404")
		@selenium_driver.find_element(:xpath, '//*[@id="lookup"]').send_keys("AAPL")
		@selenium_driver.find_element(:xpath, '//*[@id="side-menu"]/li[1]/form/div[2]/span/button').click
		@selenium_driver.find_element(:xpath, '//*[@id="amount"]').send_keys(50)
		@selenium_driver.find_element(:xpath, '//*[@id="notes"]').send_keys("Automated test purchase")
		@selenium_driver.find_element(:xpath, '//*[@id="page-wrapper"]/div/div/div[2]/div/div[2]/form/div[2]/span/button').click
		expect(@selenium_driver.find_element(:xpath, '//*[@id="page-wrapper"]/div/div/div[2]/div/div[2]/ul/li[4]').text).to eq(": 50 Shares")
	end

	it "can sell a stock" do
		facebookLogin("djg3315@gmail.com", "Password404")
		@selenium_driver.find_element(:xpath, '//*[@id="lookup"]').send_keys("AAPL")
		@selenium_driver.find_element(:xpath, '//*[@id="amount"]').send_keys(50)
		@selenium_driver.find_element(:xpath, '//*[@id="page-wrapper"]/div/div/div[3]/div/div[2]/form/div[2]/span/button').click
		expect(@selenium_driver.find_element(:xpath, '//*[@id="page-wrapper"]/div/div/div[2]/div/div[2]/ul/li[4]').text).to eq(": 0 Shares")

	it "can view the activity tracker via the link on the left nav bar" do
		facebookLogin("djh3315@gmail.com", "Password404")
		@selenium_driver.find_element(:xpath, '//*[@id="side-menu"]/li[3]/a').click
		expect(@selenium_driver.current_url).to eq("https://nameless-ravine-8460.herokuapp.com/activity")
	end

	it "can view the calendar via the link on the left nav bar" do
		facebookLogin("djh3315@gmail.com", "Password404")
		@selenium_driver.find_element(:xpath, '//*[@id="side-menu"]/li[3]/a').click
		expect(@selenium_driver.current_url).to eq("https://nameless-ravine-8460.herokuapp.com/calendar")
	end
end
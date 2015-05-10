class ReportsController < ApplicationController
	require 'net/http'
	def index
		if params['lookup'].blank?
			#Render a general report with stock timeline
		else
			remote_conn = Faraday.new(:url => "http://dev.markitondemand.com/Api/v2/Lookup") do |c|
		     # @remote_conn = Faraday.new(:url => 'http://0.0.0.0:3030') do |c|
		      c.use Faraday::Request::UrlEncoded  # encode request params as "www-form-urlencoded"
		      c.use Faraday::Response::Logger     # log request & response to STDOUT
		      c.use Faraday::Adapter::NetHttp     # perform requests with Net::HTTP
		    end
		    @symbol = JSON.parse(remote_conn.get("JSON?input=#{params['lookup']}").body)

		    remote_conn = Faraday.new(:url => "http://dev.markitondemand.com/Api/v2/Quote") do |c|
		     # @remote_conn = Faraday.new(:url => 'http://0.0.0.0:3030') do |c|
		      c.use Faraday::Request::UrlEncoded  # encode request params as "www-form-urlencoded"
		      c.use Faraday::Response::Logger     # log request & response to STDOUT
		      c.use Faraday::Adapter::NetHttp     # perform requests with Net::HTTP
		    end
		    @report = JSON.parse(remote_conn.get("JSON?symbol=#{@symbol.first['Symbol']}").body)
		    if @report['Message']
		    	@report = nil
		    end
		    @stock = Stock.find_by(symbol: "#{@symbol.first['Symbol']}")
		    # raise @report.inspect
		end
	end

	def purchase
		user = current_user
		@stock = Stock.find_or_create_by(symbol: params['symbol'], user_id: user.id)
		@stock.amount.nil? ? @stock.amount = 0 : @stock.amount
		@stock.amount = @stock.amount + params['amount'].to_i
		value = params['price']
		@stock.transactions.create(stock: @stock, transaction_type: "Purchase", value: value)
		@stock.save
		redirect_to welcome_path
	end
end

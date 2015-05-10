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
		    unless @symbol.blank?
			    @report = JSON.parse(remote_conn.get("JSON?symbol=#{@symbol.first['Symbol']}").body)
			    if @report['Message']
			    	@report = nil
			    end
			    @stock = Stock.find_or_create_by(symbol: "#{@symbol.first['Symbol']}", user: current_user)
			    # raise @report.inspect
			    @transactions = {}
			    counter = 0
			    # raise @stock.inspect
		    	@stock.transactions.order('created_at DESC').each do |t|
		    		@transactions[counter] = t
		    		counter = counter + 1
		    	end
		    else
		    	@report = nil
		    end
		end
	end

	def purchase
		# raise params.inspect
		user = current_user
		@stock = Stock.find_or_create_by(symbol: params['symbol'], user_id: user.id)
		@stock.amount.nil? ? @stock.amount = 0 : @stock.amount
		@stock.amount = @stock.amount + params['amount'].to_i
		value = params['price'] * params['amount'].to_i
		@stock.transactions.create(stock: @stock, user: user, transaction_type: "Purchase", value: value, notes: params['notes'])
		@stock.save
		flash[:notice] = "Successfully Purchased Stock."
		redirect_to :controller => 'reports', :action => 'index', :lookup => params['symbol']
		# redirect_to reports_path, lookup: params['symbol']
	end

end

class StocksController < ApplicationController
	def sell
		# raise params.inspect
		user = current_user
		@stock = Stock.find_or_create_by(symbol: params['symbol'], user_id: user.id)
		if params['amount'].to_i > @stock.amount
			flash[:alert] = "You do not have enough shares to sell that many!"
			redirect_to :controller => 'reports', :action => 'index', :lookup => params['symbol']
		else
			# raise params['amount']
			value = (params['price'].to_f * params['amount'].to_i) * (-1)
			@stock.amount = @stock.amount - params['amount'].to_i
			@stock.transactions.create(stock: @stock, user: user, transaction_type: "Sale", value: value, notes: params['notes'])
			@stock.save
			flash[:notice] = "Successfully Sold Stock."
			redirect_to :controller => 'reports', :action => 'index', :lookup => params['symbol']
		end
	end

	def top
		remote_conn = Faraday.new(:url => "http://dev.markitondemand.com/Api/v2/Quote") do |c|
	     # @remote_conn = Faraday.new(:url => 'http://0.0.0.0:3030') do |c|
	      c.use Faraday::Request::UrlEncoded  # encode request params as "www-form-urlencoded"
	      c.use Faraday::Response::Logger     # log request & response to STDOUT
	      c.use Faraday::Adapter::NetHttp     # perform requests with Net::HTTP
	    end
	    @stock_reports = [];
	    current_user.stocks.each do |stock|
	    	report = JSON.parse(remote_conn.get("JSON?symbol=#{stock.symbol}").body)
	    	stock.high = report["High"]
	    	stock.low = report["Low"]
	    	stock.open = report["Open"]
	    	stock.save
	    	@stock_reports << report
	    end
	    # raise @stock_reports.inspect
	    render json: @stock_reports
	end
end

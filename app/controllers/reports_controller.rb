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


		    	chart_data = {
		    		type: "line",
		    		width: "100%",
		    		renderAt: "chart-container",
				    dataSource: {
				    	:chart => {
					        :caption => "Your Stock Activity",
					        :xAxisName => "Day",
					        :yAxisName => "Value",
					        :lineThickness => "2",
					        :paletteColors => "#0075c2",
					        :baseFontColor => "#333333",
					        :baseFont => "Helvetica Neue,Arial",
					        :captionFontSize=> "14",
					        :subcaptionFontSize=> "14",
					        :subcaptionFontBold=> "0",
					        :showBorder=> "0",
					        :bgColor=> "#ffffff",
					        :showShadow=> "0",
					        :canvasBgColor=> "#ffffff",
					        :canvasBorderAlpha=> "0",
					        :divlineAlpha=> "100",
					        :divlineColor=> "#999999",
					        :divlineThickness=> "1",
					        :divLineDashed=> "1",
					        :divLineDashLen=> "1",
					        :divLineGapLen=> "1",
					        :showXAxisLine=> "1",
					        :xAxisLineThickness=> "1",
					        :xAxisLineColor=> "#999999",
					        :showAlternateHGridColor=> "0"
					    },
					    data: [
					        {
					            label: "Mon",
					            value: "15123"
					        },
					        {
					            label: "Tue",
					            value: "14233"
					        },
					        {
					            label: "Wed",
					            value: "23507"
					        },
					        {
					            label: "Thu",
					            value: "9110"
					        },
					        {
					            label: "Fri",
					            value: "15529"
					        },
					        {
					            label: "Sat",
					            value: "20803"
					        },
					        {
					            label: "Sun",
					            value: "19202"
					        }
					    ]
					}
				}

				@chart = Fusioncharts::Chart.new(chart_data)
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

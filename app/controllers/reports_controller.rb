class ReportsController < ApplicationController
	require 'net/http'
	def index
		if params['lookup'].blank?
			#Render a general report with stock timeline
		else
			remote_conn = Faraday.new(:url => "http://dev.markitondemand.com/Api/v2/Quote") do |c|
		     # @remote_conn = Faraday.new(:url => 'http://0.0.0.0:3030') do |c|
		      c.use Faraday::Request::UrlEncoded  # encode request params as "www-form-urlencoded"
		      c.use Faraday::Response::Logger     # log request & response to STDOUT
		      c.use Faraday::Adapter::NetHttp     # perform requests with Net::HTTP
		    end
		    @report = JSON.parse(remote_conn.get("JSON?symbol=#{params['lookup']}").body)
		    if @report['Message']
		    	@report = nil
		    end
		    # raise @report.inspect
		end
	end
end

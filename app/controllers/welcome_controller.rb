require 'koala'
class WelcomeController < ApplicationController
	# before_action :authenticate_user!
  def index
  	# raise current_user.inspect
    unless current_user.nil?
      @user = current_user
      @graph = Koala::Facebook::API.new(@user.auth_token)
      @posts = @graph.get_connection('me', 'home',
                    {limit: 25,
                      fields: ['message', 'id', 'from', 'type',
                                'picture', 'link', 'created_time', 'updated_time'
                        ]})
      # raise @posts.inspect
	  @myself = @graph.get_connection('me', 'statuses',
	  	{limit: 1,
	  		fields: ['message', 'id', 'created_time', 'updated_time']})
  		chart_data = {
			:height => 400,
			:width => 600,
			:type => 'mscolumn2d',
			:renderAt => 'chart-container',
			:dataSource => {
				:chart => {
					:caption => 'Comparison of Stock High/Open/Low',
					:subCaption => 'Your Stock',
					:xAxisname => 'Stock',
					:yAxisName => 'Amount ($)',
					:numberPrefix => '$',
					:theme => 'fint',
				},
				:categories => [{
					:category => []
				}],
				:dataset =>  [{
					:seriesname => 'High',
					:data =>  []},{
					:seriesname => 'Open',
					:data =>  []},{
					:seriesname => 'Low',
					:data =>  []}
				]
			}
		}
		
		@user.stocks.each do |stock|
			chart_data[:dataSource][:dataset][0][:data] << { value: stock.high.to_s }
			chart_data[:dataSource][:dataset][1][:data] << { value: stock.open.to_s }
			chart_data[:dataSource][:dataset][2][:data] << { value: stock.low.to_s }
			chart_data[:dataSource][:categories][0][:category] << { label: stock.symbol }
		end
		@chart = Fusioncharts::Chart.new(chart_data)
    else
      @user = nil
    end
  end

  def post 
  	@user = current_user
  	@graph = Koala::Facebook::API.new(@user.auth_token)
  	@graph.put_wall_post(params['status'])
  	redirect_to welcome_path
  	# raise params.inspect
  end
end

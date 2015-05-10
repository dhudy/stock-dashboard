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
			@stock.transactions.create(stock: @stock, transaction_type: "Sale", value: value, notes: params['notes'])
			@stock.save
			flash[:notice] = "Successfully Sold Stock."
			redirect_to :controller => 'reports', :action => 'index', :lookup => params['symbol']
		end
	end
end

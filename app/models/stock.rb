class Stock < ActiveRecord::Base
	has_many :transactions
	belongs_to :user

	def value(current_price)
		return amount * current_price unless amount.nil?
	end
end

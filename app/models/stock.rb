class Stock < ActiveRecord::Base
	has_many :transactions
	belongs_to :user

	def value(current_price)
		if amount.nil?
			return nil
		end
		value = amount * current_price
		value
	end
end

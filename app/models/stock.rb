class Stock < ActiveRecord::Base
	has_many :transactions
	belongs_to :user

	def value
		value = 0
		transactions.each do |transaction|
			value = value + transaction.value
		end
		value
	end
end

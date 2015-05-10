class AddTransactionTypeToTransactions < ActiveRecord::Migration
  def change
  	add_column :transactions, :transaction_type, :text
  end
end

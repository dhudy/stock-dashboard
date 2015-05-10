class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.references :stock, index: true
      t.string :type

      t.timestamps
    end
  end
end

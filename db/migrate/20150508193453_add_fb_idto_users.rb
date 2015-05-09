class AddFbIdtoUsers < ActiveRecord::Migration
  def change
  	change_table :users do |t|
  		t.string :fb_id
  	end
  end
end

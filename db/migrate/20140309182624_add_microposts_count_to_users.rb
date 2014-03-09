class AddMicropostsCountToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :microposts_count, :integer, default: 0
  end
end

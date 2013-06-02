class AddCustomerLifetimeValueToDataset < ActiveRecord::Migration
  def change
    add_column :datasets, :customer_lifetime_value, :integer
  end
end

class AddAverageMonthlyRevenuePerCustomerToDataset < ActiveRecord::Migration
  def change
    add_column :datasets, :average_monthly_revenue_per_customer, :integer
  end
end

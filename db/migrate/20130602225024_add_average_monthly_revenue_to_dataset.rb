class AddAverageMonthlyRevenueToDataset < ActiveRecord::Migration
  def change
    add_column :datasets, :average_monthly_revenue, :integer
  end
end

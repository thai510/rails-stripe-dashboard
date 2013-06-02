class AddChurnRateToDataset < ActiveRecord::Migration
  def change
    add_column :datasets, :churn_rate, :float
  end
end

class AddChurnToDataset < ActiveRecord::Migration
  def change
    add_column :datasets, :churn, :integer
  end
end

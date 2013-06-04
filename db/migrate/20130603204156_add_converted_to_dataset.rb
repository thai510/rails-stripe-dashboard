class AddConvertedToDataset < ActiveRecord::Migration
  def change
    add_column :datasets, :converted, :integer
  end
end

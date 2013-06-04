class AddFailedToConvertToDataset < ActiveRecord::Migration
  def change
    add_column :datasets, :failed_to_convert, :integer
  end
end

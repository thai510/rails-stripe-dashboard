class CreateDatasets < ActiveRecord::Migration
  def change
    create_table :datasets do |t|
      t.integer :trialing
      t.integer :active
      t.integer :canceled
      t.integer :unpaid
      t.integer :past_due
      t.integer :active_canceled_at_period_end
      t.integer :trialing_canceled_at_period_end
      t.integer :charges_today
      t.integer :amount_charged_today
      t.integer :amount_refunded_today
      t.integer :refunds_today

      t.timestamps
    end
  end
end

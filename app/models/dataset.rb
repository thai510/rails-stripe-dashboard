class Dataset < ActiveRecord::Base
  attr_accessible :active, :active_canceled_at_period_end, :amount_charged_today, :amount_refunded_today, :canceled, :charges_today, :past_due, :refunds_today, :trialing, :trialing_canceled_at_period_end, :unpaid
end

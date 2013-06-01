module DashboardHelper

    def updateMetrics
       set = updateCustomerMetrics(Dataset.new)
       set = updateChargeMetrics(set) 
       set.save!
    end

    def updateCustomerMetrics(set)
        count = 100
        offset = 0
        @customers = Stripe::Customer.all(:offset => offset, :count => count)
        while offset <= @customers.count
            @customers.data.each do |customer|
                if customer.subscription
                    if customer.subscription.cancel_at_period_end
                        if customer.subscription.status == 'trialing'      
                            set.trialing_canceled_at_period_end = (set.trialing_canceled_at_period_end || 0) + 1         
                        else
                            set.active_canceled_at_period_end = (set.active_canceled_at_period_end || 0) + 1
                        end
                    else
                        if customer.subscription.status == 'trialing'
                            set.trialing = (set.trialing || 0) + 1
                        elsif customer.subscription.status == 'active'
                            set.active = (set.active || 0) + 1
                        elsif customer.subscription.status == 'unpaid'
                            set.unpaid = (set.unpaid || 0) + 1
                        elsif customer.subscription.status == 'past_due'
                            set.past_due = (set.past_due || 0) + 1
                        elsif customer.subscription.status == 'canceled'
                            set.canceled = (set.canceled || 0) + 1
                        end
                    end
                else #they're a canceled customer
                    set.canceled = (set.canceled || 0 ) + 1
                end

            end
            offset += count
            @customers = Stripe::Customer.all(:offset => offset, :count => count)
        end

        return set
    end
    
    def updateChargeMetrics(set)
        count = 100
        offset = 0
        @charges = Stripe::Charge.all(:offset => offset, :count => count, :created => {:gte => 1.day.ago.to_i})
        while offset <= @charges.count
            @charges.data.each do |charge|
                set.charges_today = (set.charges_today || 0) + 1
                set.refunds_today = (set.refunds_today || 0) + 1 if charge.refunded
                set.amount_charged_today = (set.amount_charged_today || 0) + charge.amount
                set.amount_refunded_today = (set.amount_refunded_today || 0) + charge.amount_refunded
            end
            offset += count
            @charges = Stripe::Charge.all(:offset => offset, :count => count)
        end

        return set
    end
end

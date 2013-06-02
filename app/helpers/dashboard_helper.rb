module DashboardHelper

    def updateMetrics
        set = updateCustomerMetrics(Dataset.new)
        set = updateChargeMetrics(set)
        set = churn(set)
        set = customer_lifetime_value(set)
        set = average_monthly_revenue(set)
        set.save!
    end

    def updateCustomerMetrics(set)
        count = 100
        offset = 0
        set.average_monthly_revenue_per_customer = 0
        @customers = Stripe::Customer.all(:offset => offset, :count => count)
        while offset <= @customers.count
            @customers.data.each do |customer|
                next if not customer.livemode
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
                            if customer.subscription.plan.interval == 'month'
                                set.average_monthly_revenue_per_customer += customer.subscription.plan.amount
                            else
                                set.average_monthly_revenue_per_customer += customer.subscription.plan.amount / 12
                            end
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

        set.average_monthly_revenue_per_customer /= set.active

        return set
    end

    def updateChargeMetrics(set)
        count = 100
        offset = 0
        @charges = Stripe::Charge.all(:offset => offset, :count => count).to_hash[:data]
        while offset <= @charges.count
            @charges.each do |charge|
                charge = charge.to_hash
                next if charge[:livemode] == false or charge[:created] < 1.day.ago.to_i
                set.charges_today = (set.charges_today || 0) + 1
                set.refunds_today = (set.refunds_today || 0) + 1 if charge[:refunded]
                set.amount_charged_today = (set.amount_charged_today || 0) + charge[:amount]
                set.amount_refunded_today = (set.amount_refunded_today || 0) + charge[:amount_refunded]
            end
            offset += count
            @charges = Stripe::Charge.all(:offset => offset, :count => count)
        end

        return set
    end

    def churn(set)
        set.churn = churn_count_past_days
        set.churn_rate = (set.churn > 0 ? (set.active / set.churn) : 0.0)
        return set
    end

    def churn_count_past_days
        count = 100
        offset = 0
        period_start = 30.days.ago.to_i
        sum = 0
        @events = Stripe::Event.all(:offset => offset, :count => count, :created => {:gte => period_start}, :type => 'customer.subscription.deleted').to_hash[:data].each do |event|
            event = event.to_hash[:data].to_hash[:object].to_hash
            next if event[:trial_end] and event[:trial_end] >= event[:canceled_at]
            sum += 1
        end
        return sum
    end

    def customer_lifetime_value(set)
        set.customer_lifetime_value = (set.average_monthly_revenue_per_customer.to_f / (set.churn.to_f / 100)).to_i.round
        return set
    end

    def average_monthly_revenue(set)
        set.average_monthly_revenue = set.active * set.average_monthly_revenue_per_customer
        return set
    end
end

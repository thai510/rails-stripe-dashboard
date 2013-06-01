module DashboardHelper

    def updateMetrics
        set = Dataset.new   
        count = 100
        offset = 0
        @customers = Stripe::Customer.all(:offset => offset, :count => count)
        while offset <= @customers.count
            @customers.data.each do |customer|
            #add the customer
            next if Customer.find_by_customer_id(customer.id)
            newCustomer = Customer.new
            newCustomer.json = customer.data
            newCustomer.customer_type = customer.type
            newCustomer.customer_id = customer.id
            newCustomer.livemode = customer.livemode
            puts "saving customer: #{newCustomer.inspect}"
            newCustomer.save!
            end
            offset += count
            @customers = Stripe::Customer.all(:offset => offset, :count => count)
        end
    end

    def getNumPayingCustomers(days_ago = 0)
    end

    def getChurn(days_ago = 30)

    end
end

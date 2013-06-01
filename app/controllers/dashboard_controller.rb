class DashboardController < ApplicationController
    before_filter :authenticate_user!
    def index
            
    end

    def update_events
        # get all the events and add them into the database
        if not $isRunningUpdate
            $isRunningUpdate = true
            updateMetrics
            $isRunningUpdate = false
        end
    end
end

class DashboardController < ApplicationController
    include DashboardHelper
    before_filter :authenticate_user!

    def index
       updateMetrics if Dataset.count == 0
       @set = Dataset.last
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

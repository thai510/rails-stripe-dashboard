class DashboardController < ApplicationController
    include DashboardHelper
    before_filter :authenticate_user!

    def index
       updateMetrics if Dataset.last.created_at.to_i < 12.hours.ago.to_i
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

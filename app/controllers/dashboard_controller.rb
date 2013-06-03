class DashboardController < ApplicationController
    include DashboardHelper
    before_filter :authenticate_user!

    def index
       updateMetrics if Dataset.count == 0 or Dataset.last.created_at.to_i < 12.hours.ago.to_i
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

    def graph_data
        respond_to do |format|
            format.json { render :json => 
                (params[:which].collect do |w|
                    {
                        name: w,
                        data: Dataset.last(30).collect do |d|
                            {
                                x: d.created_at.to_i,
                                y: d[w]
                            }
                        end
                    }
                end)
            }
        end
    end
end

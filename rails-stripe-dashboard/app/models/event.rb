class Event < ActiveRecord::Base
  attr_accessible :event_id, :event_type, :json, :livemode
end

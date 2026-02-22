class EventsController < ApplicationController
  before_action :require_volunteer

  def index
    @events = Event.order(event_date: :asc, start_time: :asc)
  end

  def show
    @event = Event.find(params[:id])
  end
end

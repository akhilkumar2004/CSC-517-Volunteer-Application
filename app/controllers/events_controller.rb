class EventsController < ApplicationController
  before_action :require_login
  before_action :set_event, only: [:show]

  def index
    @events = Event
                .includes(:volunteer_assignments)
                .order(event_date: :asc, start_time: :asc)
  end

  def show
    # @event is set by before_action
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end
end
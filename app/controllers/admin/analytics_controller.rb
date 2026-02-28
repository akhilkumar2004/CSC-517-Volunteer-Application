class Admin::AnalyticsController < ApplicationController
    before_action :require_login

    def index
      @events = Event.order(event_date: :asc)
      @volunteers = Volunteer.order(:full_name)

      assignments = VolunteerAssignment.completed.includes(:volunteer, :event)

      if params[:event_id].present?
        assignments = assignments.where(event_id: params[:event_id])
      end

      if params[:volunteer_id].present?
        assignments = assignments.where(volunteer_id: params[:volunteer_id])
      end

      if params[:date_from].present?
        assignments = assignments.where("date_logged >= ?", params[:date_from])
      end

      if params[:date_to].present?
        assignments = assignments.where("date_logged <= ?", params[:date_to])
      end

      @assignments = assignments

      @volunteer_activity = assignments.group_by(&:volunteer).map do |volunteer, rows|
        total_hours = rows.sum { |row| row.hours_worked.to_f }
        events_count = rows.map(&:event_id).uniq.size
        avg_hours = events_count.positive? ? (total_hours / events_count) : 0

        {
          volunteer: volunteer,
          events_count: events_count,
          total_hours: total_hours,
          average_hours: avg_hours
        }
      end.sort_by { |row| row[:volunteer].full_name }

      @event_participation = assignments.group_by(&:event).map do |event, rows|
        total_hours = rows.sum { |row| row.hours_worked.to_f }
        volunteers_count = rows.map(&:volunteer_id).uniq.size
        avg_hours = volunteers_count.positive? ? (total_hours / volunteers_count) : 0

        {
          event: event,
          volunteers_count: volunteers_count,
          total_hours: total_hours,
          average_hours: avg_hours
        }
      end.sort_by { |row| row[:event].event_date }

      top_n = params[:top_n].presence&.to_i || 5
      top_sort = params[:top_sort].presence || "hours"

      @top_volunteers = @volunteer_activity.sort_by do |row|
        top_sort == "events" ? -row[:events_count] : -row[:total_hours]
      end.first(top_n)

      completed_ids = assignments.pluck(:volunteer_id).uniq
      @low_participation = Volunteer.where.not(id: completed_ids).order(:full_name)
    end
  end



class Spots::IcalendarEvent
  require 'icalendar'
  include Rails.application.routes.url_helpers

  def initialize(spot:)
    @spot = spot
    @url = spot_url(@spot)
  end

  def call
    ical = ::Icalendar::Calendar.new
    event = ::Icalendar::Event.new
    event.dtstart = Icalendar::Values::DateTime.new @spot.start_date
    event.dtend = Icalendar::Values::DateTime.new @spot.end_date
    event.summary = @spot.title
    event.description = "Meeting with: #{@spot.title}, Hamaki"
    event.uid = @spot.id.to_s # important for updating/canceling an event
    event.sequence = Time.now.to_i # important for updating/canceling an event
    event.url = @url
    # event.organizer = "mailto:organizer@example.com"
    #event.organizer = Icalendar::Values::CalAddress.new("mailto:#{ApplicationMailer.default_params[:from]}", cn: 'Yaro from Superails')
    event.status = 'CONFIRMED' # 'CANCELLED'
    event.ip_class = 'PUBLIC' # 'PRIVATE'
    # event.attach = Icalendar::Values::Uri.new @url
    # event.append_attach = Icalendar::Values::Uri.new(@url, "fmttype" => "application/binary")
    event.created = @spot.created_at
    event.last_modified = @spot.updated_at

    ical.add_event(event)
    ical.append_custom_property('METHOD', 'REQUEST') # add event to calendar by default!
    ical.publish
    # ical.ip_method = 'REQUEST'
    # ical.ip_method = 'PUBLISH'
    # ical.ip_method = 'CANCEL'
    ical
  end
end
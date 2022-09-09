class SpotsController < ApplicationController
  include ActionController::HttpAuthentication::Token::ControllerMethods
  require 'icalendar/tzinfo'

  skip_before_action :verify_authenticity_token
  before_action :authenticate
  skip_before_action :authenticate, only: [:show, :index, :reserve, :complete, :show_spot, :cancel_spot, :show_ical]

  def index
      @spots = Spot.all
  end

  def show
    url_params = params[:calendar_id] + "/" + params[:name]
    @calendar = Calendar.find_by_url(url_params)
    @spots = Spot.find_week(Time.now(), @calendar.id)
  end

  def show_spot
    @spot = Spot.find_by_slug(params[:slug])
  end

  def show_ical
    @spot = Spot.find_by_slug(params[:slug])

    cal = Icalendar::Calendar.new
    filename = "Hamaki at #{@spot.created_at}"

    if params[:format] == 'vcs'
      cal.prodid = '-//Microsoft Corporation//Outlook MIMEDIR//EN'
      cal.version = '1.0'
      filename += '.vcs'
    else # ical
      cal.prodid = '-//Acme Widgets, Inc.//NONSGML ExportToCalendar//EN'
      cal.version = '2.0'
      filename += '.ics'
    end

    event_start = @spot.start_date
    event_end = @spot.end_date
    
    tzid = "Europe/Amsterdam"
    tz = TZInfo::Timezone.get tzid
    timezone = tz.ical_timezone event_start
    cal.add_timezone timezone

    cal.event do |e|
      e.dtstart = Icalendar::Values::DateTime.new event_start, 'tzid' => tzid
      e.dtend   = Icalendar::Values::DateTime.new event_end, 'tzid' => tzid
      e.summary = @spot.calendar.name
      e.description = "Meeting created by Hamaki #{@spot.slug}"
      e.organizer = "mailto:#{@spot.calendar.owner.email}"
      e.organizer = Icalendar::Values::CalAddress.new("mailto:#{@spot.calendar.owner.email}", cn:"#{@spot.calendar.owner.name}")
    end

    send_data cal.to_ical, type: 'text/calendar', disposition: 'attachment', filename: filename

  end

  def cancel_spot
    spot = Spot.find_by_slug(params[:slug])

    if spot
      unless spot.visitor_email.empty?
        spot.visitor_name = ""
        ## Check domain verification in model
        spot.visitor_email = nil
        spot.slug = ""
        spot.save
      end
    end
  end

  def delete_spots
    return unless @owner
    # loop through spot_ids from this owner
      data = JSON.parse(request.raw_post)

      data["spot_ids"].each do |id|
        spot = Spot.find(id)
        if spot
          if @owner.id == spot.calendar.owner_id
            spot.status = "delete"
            spot.save

            if spot.visitor_email
              SpotMailer.with(spot: spot).spot_deleted_mail.deliver_later
            end 
          end
        end
      end
  end

  def reserve
    spot = Spot.find(params[:spot_id])
    spot.visitor_name = params[:visitor_name]
    ## Check domain verification in model
    spot.visitor_email = params[:visitor_email]
    
    if spot.save 
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.update("sign_up_results", partial: "messages/sign_up_complete", locals: { spot: spot })
        end
      end
       SpotMailer.with(spot: spot).spot_reserved_mail.deliver_now
    end

  end

  def create
    return unless @owner

    data = JSON.parse(request.raw_post)
    result = create_spots_from_blocks(data)

    render :json => result
  end

  private

  def create_spots_from_blocks(data)
    result = []
    data.each do |calendar|
      time_per_block = calendar['recipe']['timePerSpot'].to_i
      result_calendar = Hash.new
      result_calendar[:calendar_id] = calendar['id']
      result_calendar[:created_blocks] = []
      calendar['blocks'].each do |block|
        created_block = Hash.new
        created_block[:block_id] = block['blockId']
        created_block[:spots] = []
        @calendar = Calendar.find_by_client_id(calendar['id'])
        puts block
        puts block['startTime']
        start_time = Time.at(block['startTime']).to_datetime
        end_time = Time.at(block['endTime']).to_datetime
        minutes_between = ((end_time - start_time) * 24 * 60).to_i
        total_spots = minutes_between / time_per_block -1

        # Create first
        spot = Spot.new
        spot.calendar = @calendar
        spot.start_date = Time.at(block['startTime']).to_datetime
        spot.end_date = start_time + time_per_block.minutes
        spot.save
        created_block[:spots] << spot

        #create rest
        total_spots.times do
          last_spot = Spot.last
          spot = Spot.new
          spot.calendar = @calendar
          spot.start_date = last_spot.end_date.to_datetime
          spot.end_date = last_spot.end_date.to_datetime + time_per_block.minutes

          created_block[:spots] << spot
          spot.save
        end
        result_calendar[:created_blocks] << created_block
      end
      result << result_calendar
    end
    result
  end

  def authenticate
    authenticate_or_request_with_http_token do |token|
      @owner = Owner.find_by_uuid(token)
    end
  end

  def get_decoded_params(blocks)
    JSON.parse(blocks)
  end

end

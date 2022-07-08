class SpotMailer < ApplicationMailer
  default from: 'notifications@example.com'

  def spot_reserved_mail
    @spot = params[:spot]
    mail(to: @spot.visitor_email, subject: 'Spot reserved')
  end

  def spot_deleted_mail
    @spot = params[:spot]
    mail(to: @spot.visitor_email, subject: 'Spot has been deleted')
  end
end

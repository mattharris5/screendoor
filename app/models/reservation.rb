require 'open-uri'

class Reservation < ActiveRecord::Base
  validates_presence_of :uid
  validates_uniqueness_of :uid

  default_scope -> { order("start_date ASC") }
  scope :future, -> { where("end_date > ?", Time.now) }
  scope :needs_housekeeping_scheduled, -> { where(cleaning_scheduled: false) }
  scope :needs_welcome_sent, -> { where(welcome_sent: false) }
  scope :needs_cleaning_completed, -> { where(cleaning_completed: false) }
  scope :soon, -> { where("start_date > ?", Time.now).where("start_date - ? < ?", Time.now, 5.days) }

  def current?
    start_date.past? && end_date.future?
  end

  def soon?
    start_date.future? && start_date - Time.now < 5.days
  end

  def past?
    start_date.past?
  end

  def time_until
    return nil if past?
    distance_in_minutes = ((start_date.utc - Time.now.utc)/60.0).round
    case distance_in_minutes
    when 0..1440     then [(distance_in_minutes / 60.0).round, "hour"]
    when 1440..20160 then [(distance_in_minutes / 60.0 / 24.0).round, "day"]
    else                  [(distance_in_minutes / 60.0 / 24.0 / 7).round, "week"]
    end
  end

  def self.import_from_ics(ics_file_uri = ENV['ICS_URL'] || Preference.get(:ics_url))

    # Open a file or pass a string to the parser
    cal_file = open(ics_file_uri).read

    # Parser returns an array of calendars because a single file
    # can have multiple calendars.
    cals = Icalendar.parse(cal_file)
    cal = cals.first

    for event in cal.events
      logger.info { "Importing #{event.uid}" }
      reservation = Reservation.where(uid: event.uid.to_s).first_or_initialize
      reservation.update_attributes({
        :start_date => event.dtstart,
        :end_date => event.dtend,
        :name => event.summary.to_s.split("-").try(:[], 1).try(:strip),
        :status => event.summary.to_s.split("-").try(:[], 0).try(:strip)
      })
    end

    Preference.set :reservations_imported_at, Time.now
  end

  def self.last_updated_at
    @last_updated_at ||= Preference.get :reservations_imported_at
  end
end

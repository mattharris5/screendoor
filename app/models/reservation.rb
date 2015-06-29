require 'open-uri'

class Reservation < ActiveRecord::Base
  attr_accessible :cleaning_scheduled, :end_date, :name, :start_date, :status, :uid, :welcome_sent, :cleaning_completed
  
  validates_presence_of :uid
  validates_uniqueness_of :uid

  default_scope order("start_date ASC")
  scope :future, where("end_date > ?", Time.now)
  scope :needs_housekeeping_scheduled, where(cleaning_scheduled: false)
  
  def current?
    start_date.past? && end_date.future?
  end
  
  def soon?
    start_date.future? && start_date - Time.now < 5.days
  end
  
  def self.import_from_ics(ics_file_uri = Preference.get(:ics_url))

    # Open a file or pass a string to the parser
    cal_file = open(ics_file_uri).read

    # Parser returns an array of calendars because a single file
    # can have multiple calendars.    
    cals = Icalendar.parse(cal_file)
    cal = cals.first

    for event in cal.events
      logger.info { "Importing #{event.uid}" }
      reservation = Reservation.find_or_initialize_by_uid(event.uid.to_s)
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

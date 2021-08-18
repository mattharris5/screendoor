# Screendoor

Help manage your Vrbo or Airbnb properties by tracking cleaning and communications. 

## Scheduled Jobs
* `$ rake import_reservations` - fetch the calendar feed
* `$ rails runner TaskChecker.new.cleaning_not_scheduled` - warn if cleaning hasn't been scheduled for an upcoming guest
* `$ rails runner TaskChecker.new.guest_not_welcomed` - warn if you haven't sent an upcoming guest checkin instructions


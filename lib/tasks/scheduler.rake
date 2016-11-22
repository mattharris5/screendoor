desc "Fetch the latest copy of the iCalendar file from Preference.ics_url"
task :import_reservations => :environment do
  puts "Updating events from #{Preference.get(:ics_url)}..."
  if Reservation.import_from_ics
    puts "Successfully imported"
    puts "Last updated at #{Preference.get(:reservations_imported_at).to_s}"
  else
    puts "Error"
  end
end

desc "Check if any tasks need to be completed and send emails as needed"
task :notify_incomplete_tasks => :environment do
  puts "Checking for incomplete tasks"
  if Task.notify_incomplete!
    puts "Successfully notified about incomplete tasks"
  else
    puts "Error"
  end
end

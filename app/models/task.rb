class Task
  
  # Checks for any incomplete tasks for upcoming reservations and sends an alert.
  def self.notify_incomplete!
    for task in Task.incomplete
      task.notify!
    end
  end
  
  # Returns the Reservations that have incomplete tasks attached.
  def self.incomplete
    [ Reservation.soon.needs_welcome_sent, Reservation.soon.needs_housekeeping_scheduled ].compact.uniq
  end
  
end

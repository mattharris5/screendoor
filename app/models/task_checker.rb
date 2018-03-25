require 'sendgrid-ruby'

class TaskChecker
  include SendGrid

  def initialize
  end

  def cleaning_not_scheduled
    reservations = Reservation
      .where("start_date < ?", 10.days.from_now)
      .where("start_date > ?", Time.now)
      .where("cleaning_scheduled IS NULL OR cleaning_scheduled = ?", false)

    return if reservations.empty?
    reservation = reservations.first
    message = <<~HTML
      <p>
        #{reservation.name} arrives on #{reservation.start_date.strftime("%A, %b %d")} and has not had cleaning arranged!
      </p>

      <p style="font-size: 75%">
        <a href="#{mail_url(path: "/reservations/housekeeping")}">Open in Screendoor</a>
      </p>
    HTML
    send_mail(subject: "Guest needs cleaning arranged", text: message)
  end

  def guest_not_welcomed
    reservations = Reservation
      .where("start_date < ?", 3.days.from_now)
      .where("start_date > ?", Time.now)
      .where("welcome_sent IS NULL OR welcome_sent = ?", false)

    return if reservations.empty?
    reservation = reservations.first
    message = <<~HTML
      <p>
        #{reservation.name} arrives on #{reservation.start_date.strftime("%A")} and has not received a welcome email!
      </p>

      <p style="font-size: 75%">
        <a href="#{mail_url(path: "/reservations/#{reservation.id}/edit")}">Open in Screendoor</a>
      </p>
    HTML
    send_mail(subject: "Guest arrives in less than 3 days", text: message)
  end

  protected

  def send_mail(message_params = {})
    puts "Sending mail: #{message_params.inspect}"
    from = Email.new(email: 'screendoor@bettascove.com')
    to = Email.new(email: ENV['ADMIN_EMAIL'])
    subject = message_params[:subject]
    content = Content.new(type: 'text/html', value: message_params[:text])
    mail = Mail.new(from, subject, to, content)

    sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
    response = sg.client.mail._('send').post(request_body: mail.to_json)
    puts response.status_code
    puts response.body
    puts response.headers
  end

  def mail_url(path: "/")
    URI::HTTPS.build(
      host:     ENV.fetch("BASE_HOST"),
      userinfo: [ENV.fetch("LOGIN_USERNAME"), ENV.fetch("LOGIN_PASSWORD")].join(":"),
      path:     path
    )
  end

end

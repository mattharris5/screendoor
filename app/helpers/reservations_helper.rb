module ReservationsHelper
  def reservation_type_tag(reservation_type = "Reserved")
    css_class, icon = case reservation_type
    when "Reserved"   then ["success", "check"]
    when "Blocked"    then ["default", "ban"]
    when "Tentative"  then ["danger",  "question"]
    end
    content_tag :span, fa(icon) + " " + reservation_type, class: "label label-#{css_class}"
  end
end

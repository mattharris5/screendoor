module ApplicationHelper

  def fa(icon_key, additional_class = nil)
    content_tag :i, "", class: "fa fa-#{icon_key.to_s} #{additional_class}"
  end

  def checkmark(text = nil, state = false)
    out = state ? fa("check-circle", "success fa-lg") : fa(:minus, "muted fa-lg")
    out += content_tag(:span, text, class: "hidden-lg checkmark-label") if text
    out
  end

  def alert_class_for(flash_type)
    case flash_type.to_s
      when "success"
        "alert-success"   # Green
      when "error"
        "alert-danger"    # Red
      when "alert"
        "alert-warning"   # Yellow
      when "notice"
        "alert-info"      # Blue
      else
        flash_type.to_s
    end
  end

end

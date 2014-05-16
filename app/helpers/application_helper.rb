module ApplicationHelper
  def title(content)
    content_for(:title, content)
  end

  def page_title
    delimiter = '|'
    if content_for?(:title)
      "#{delimiter} #{content_for(:title)}"
    end
  end

  def flash_class(level)
    case level
      when 'notice', 'info' then "alert alert-info"
      when 'success' then "alert alert-success"
      when 'alert', 'warning' then "alert alert-warning"
      when 'error', 'danger' then "alert alert-danger"
    end
  end
end

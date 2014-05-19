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

  def gravatar_url(email, size)
    defaultImage = "http://lh5.googleusercontent.com/-b0-k99FZlyE/AAAAAAAAAAI/AAAAAAAAAAA/twDq00QDud4/s#{size}-c/photo.jpg";
    gravatar_id = Digest::MD5::hexdigest(email).downcase
    
    "http://gravatar.com/avatar/#{gravatar_id}.png?d=#{defaultImage}&s=#{size}"
  end
end

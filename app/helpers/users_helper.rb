module UsersHelper
  def render_count(count)
    if count == 0
      label_type = 'label-default'
    elsif count < 5
      label_type = 'label-primary'
    elsif count < 10
      label_type = 'label-success'
    elsif count < 20
      label_type = 'label-info'
    elsif count < 50
      label_type = 'label-warning'
    elsif count >= 50
      label_type = 'label-danger'
    end

    count = count > 999 ? '999+' : count

    "<span class=\"label #{label_type} label-total\">#{ count }</span>"
  end
end

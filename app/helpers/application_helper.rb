module ApplicationHelper
  def bootstrap_class_for(flash_type)
    {
      success: 'alert-success',
      error: 'alert-danger',
      alert: 'alert-warning',
      notice: 'alert-primary'
    }[flash_type.to_sym] || flash_type.to_s
  end

  def plutus_to_badge(account_type)
    "badge badge-pill badge-#{Cuenta::COLORS[account_type]}"
  end

  def plutus_to_tr(account_type)
    "table-border-#{Cuenta::COLORS[account_type]}"
  end

  def trash_icon
    "<i class='fas fa-trash'></i>".html_safe
  end

  def plus_icon
    "<i class='fas fa-plus'></i>".html_safe
  end

  def menu_link(title, path)
    active_link_to(title, path, class: 'nav-item nav-link')
  end

  def submenu_link(title, path, params=:exclusive)
    active_link_to(title, path, class: 'dropdown-item', active: params)
  end

  def row_class(object, id)
    klazz = []
    klazz << 'item-highlight' if object.id == id
    klazz << 'item-discarded' if object.discarded?

    klazz.join(' ')
  end

  def money(value)
    return "$" unless value
    formatted_value = number_with_precision(value, precision: 2, delimiter: ',')
    puts formatted_value
    render partial: 'partials/money', locals: { value: formatted_value }
  end

end

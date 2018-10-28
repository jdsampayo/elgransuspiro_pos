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
    "table-#{Cuenta::COLORS[account_type]}"
  end
end

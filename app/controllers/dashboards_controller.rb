class DashboardsController < ApplicationController
  def index
    today = Time.now.beginning_of_day
    @days = [
      today,
      today - 1.days,
      today - 2.days,
      today - 3.days,
      today - 4.days,
      today - 5.days,
      today - 5.days,
      today - 7.days
    ]
  end
end

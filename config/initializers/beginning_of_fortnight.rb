#
# Extend Time to provide a beginning_of_fortnight and an
# end_of_fortnight method
#
def beginning_of_fortnight(time)
  if time.day < 15
    (time - time.day.days + 1.days).beginning_of_day
  else
    (time - time.day.days + 16.days).beginning_of_day
  end
end

def end_of_fortnight(time)
  if time.day < 15
    (beginning_of_fortnight(time) + 14.days).end_of_day
  else
    time.end_of_month
  end
end


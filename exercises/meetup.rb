require 'date'

class Meetup
  POSITION = {:first => 0, :second => 1, :third =>2, :fourth =>3, :last => -1 }

  def initialize(month, year)
    @month = month
    @year = year
  end

  def day(day_of_week, schedule)
    Date.new(@year, @month, choose_right_day(gather_days_of_month(day_of_week), schedule))
  end

  def choose_right_day(possible_dates, schedule)
    if schedule == :teenth
      correct_date = possible_dates.detect { |date| date >= 13 && date <= 19 }
    else
      correct_date = possible_dates[POSITION[schedule]]
    end
  end

  def gather_days_of_month(day_of_week)
    date_range = Date.new(@year, @month, 1)..Date.new(@year, @month, 1).next_month.prev_day
    day_of_week = day_of_week.to_s.concat("?")
    result = date_range.select {|day_of_month| day_of_month.send(day_of_week) }.map(&:day)
  end
end
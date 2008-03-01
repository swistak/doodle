require 'date'
require 'doodle'

class DateRange < Doodle::Base 
  has :start_date do
    default { Date.today }
  end
  has :end_date do
    default { start_date }
  end
end

dr = DateRange.new
dr.start_date                   # =>
dr.end_date                     # =>


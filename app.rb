require 'sinatra'
require 'yaml'

class RangedHash < Hash
  def [](key)
    each_pair do |range, value|
      return value if range.include?(key)
    end
    nil
  end
end

def messages
  unless @messages
    @messages = RangedHash.new({})
    YAML::load(File.open('messages.yaml', 'r')).each do |item|
      @messages[Range.new(item[:begin], item[:end], item[:excl])] = item[:message]
    end
  end
  @messages
end

puts messages.inspect

GOAL_FOR_THE_MONTH = 40.0
GOAL_FOR_EACH_DAY  = 4.0

def total_for_today(today)
  times = %x[punch total php --after #{today} --before #{today+1}].gsub("\"",'').strip.split(':')
  times.unshift("0") if times.size < 3
  "%0.1f" % [times[0].to_i + (times[1].to_i / 60.0)]
end

def total_for_this_month(today)
  first_of_the_month = Date.new(today.year, today.month)
  next_month         = Date.new(today.year, today.month+1)
  monthly = %x[punch total php --after #{first_of_the_month} --before #{next_month}].gsub("\"",'').strip.split(':')
  monthly.unshift("0") if monthly.size < 3
  ("%0.2f" % [monthly[0].to_i + (monthly[1].to_i / 60.0)]).to_f
end

def tell_me_like_it_is(current_monthly_total)
  messages[current_monthly_total / GOAL_FOR_THE_MONTH]
end

get '/' do
  @daily_goal = GOAL_FOR_EACH_DAY
  @today = Date.today
  @total = total_for_today(@today)

  @monthly_goal  = GOAL_FOR_THE_MONTH
  @monthly_total = total_for_this_month(@today)
  @motivation    = tell_me_like_it_is(@monthly_total)
  erb :"index.html"
end

require 'sinatra'

GOAL_FOR_THE_MONTH = 40.0
GOAL_FOR_EACH_DAY  = 4.0

def total_for_today(today)
  times = %x[punch total php --after #{today} --before #{today+1}].gsub("\"",'').strip.split(':')
  times.unshift("0") if times.size < 3
  "%0.1f" % [times[0].to_i + (times[1].to_i / 60.0)]
end

def total_for_this_month(today)
  first_of_the_month = Date.new(today.year, today.month)
  end_of_the_month   = Date.new(today.year, today.month+1)
  %x[punch total php --after #{first_of_the_month} --before #{end_of_the_month}].gsub("\"",'').strip.split(':')[0].to_f
end

def tell_me_like_it_is(current_monthly_total)
  case current_monthly_total / GOAL_FOR_THE_MONTH
  when 0..0.05
    "Pussy"
  when 0.05..0.15
    "Dude, you're fucking pathetic!"
  when 0.15..0.25
    "Seriously... Seriously? Seriously."
  when 0.25..0.50
    "You are a moist toilette"
  when 0.50..0.65
    "You're getting warm."
  when 0.65..0.80
    "You can do it!"
  when 0.80..0.99
    "Atta Boy!"
  when 0.99..1.10
    "That's a bingo!"
  when 1.10..5.00
    "Damn, motherfucker. \nYou making bank!"
  end
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

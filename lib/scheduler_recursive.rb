require 'pry'
require 'Forwardable'
require_relative "../lib/calendar"
require_relative "../lib/date_inspector"

class SchedulerRecursive
  extend Forwardable
  def_delegators :@cal

  def_delegators :@inspector,
                 :special_hours?,
                 :open?,
                 :get_closing

  attr_reader :cal,
              :drop_off,
              :date,
              :duration,
              :inspector

  def initialize(calendar, drop_off, duration)
    @cal = calendar
    @drop_off = Time.parse(drop_off)
    @date = Date.parse(drop_off)
    @duration = duration
    @inspector = DateInspector.new(cal, date)
  end

  def run
    get_pickup(drop_off, duration)
  end

  private

    def get_pickup(date, duration)
      if DateInspector.new(cal, @date).open?
        if DateInspector.new(cal, @date).special_hours?
          if (date + duration) < DateInspector.new(cal, @date).get_special_closing
            return date + duration
          else

          end
        else
          if (date + duration) < DateInspector.new(cal, @date).get_closing
            return date + duration
          else
            remaining_duration = duration - (DateInspector.new(cal, @date).get_closing - date)
            @date = get_openning(date + 60 * 60 * 24)
            get_pickup(@date, remaining_duration)
          end
        end
      else
        @date = get_openning(date + 60 * 60 * 24)
        get_pickup(@date, duration)
      end
    end

    def get_openning(date)
      DateInspector.new(cal, date).get_openning
    end

end

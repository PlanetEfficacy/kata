# Solution Notes

#### Class documentation

# The Challenge
<table>
  <thead>
    <tr><td><b>Class</b></td><td><b>Notes</b></td></tr>
  </thead>
  <tbody>
    <tr><td>Service</td><td>Has a name, duration and price</td></tr>
    <tr><td>Package</td><td>A collection of services with a name, duration, and price</td></tr>
    <tr><td>Shop</td><td>Has a name, has a menu of services and packages, has a calendar with hours of operation and can take on a job.</td></tr>
    <tr><td>Job</td><td>Belongs to a shop and has many services and or packages.</td></tr>
    <tr><td>Calendar</td><td>Holds the ours of operation for a shop. Can set normal business hours, special business hours, and closed days.</td></tr>
    <tr><td>Date Inspector</td><td>Handles queries about single days, such as is the shop open, is it running special hours, and what are the hours. </td></tr>
    <tr><td>Scheduler</td><td>Takes a calendar, drop off time, and job duration, and recursively searches over the calendar to find the soonest possible pick up time. It takes into account normal business hours, special business hours, durations that extend beyond business hours, and durations that extend beyond many business hours.</td></tr>
  </tbody>
</table>

_Steezy's_ is a full-service ski & snowboard shop known for its speedy service. The problem is, when a customer drops off their equipment, they need to know how much it costs and what time it will be available for pickup.

Steezy's offers four à la carte services:

<table>
  <thead>
    <tr><td><b>Service</b></td><td><b>Duration</b></td></tr>
  </thead>
  <tbody>
    <tr><td>Wax</td><td>15 minutes</td></tr>
    <tr><td>Edge</td><td>25 minutes</td></tr>
    <tr><td>Base</td><td>12 minutes</td></tr>
    <tr><td>P-Tex</td><td>20 minutes</td></tr>
  </tbody>
</table>

And three packages:

<table>
  <thead>
    <tr><td><b>Package</b></td><td><b>Included Services</b></td></tr>
  </thead>
  <tbody>
    <tr><td>Basic</td><td>Wax, Edge</td></tr>
    <tr><td>Deluxe</td><td>Wax, Edge, Base</td></tr>
    <tr><td>Performance</td><td>Wax, Edge, Base, P-Tex</td></tr>
  </tbody>
</table>

The shop rate is $80.00 / hour.

<hr>

It is your job to write a Ruby program which will determine the pickup time for a customer job given Steezy's business hour schedule.

Create a class called `Calendar` which allows one to define the opening and closing time for each day's business hours. It should provide the following interface:

```ruby
calendar = Calendar.new
calendar.open("9:00 AM", "3:00 PM")                  # Normally opens at 9am and closes at 3pm
calendar.update(:fri, "10:00 AM", "5:00 PM")         # Opens at 10am and closes at 5pm every Friday
calendar.update("Sep 3, 2016", "8:00 AM", "1:00 PM") # Special hours the Saturday before Labor Day
calendar.closed(:sun, :tue, "Sep 5, 2016")           # Closed on Sundays, Tuesdays, and Labor Day
```

The open method should specify the normal business hours. The update method should change the opening and closing time for a given day. The closed method should specify which days the shop is not open. Notice days can either be a symbol for week days or a string for specific dates. Any given day can only have one opening time and one closing time — there are no off-hours in the middle of the day.

Create another class called `Job` which represents a set of services to perform for the customer. It should provide the following interface:

```ruby
job = Job.new(:wax)          #=> single service
job.duration                 #=> 900 (seconds)
job.price                    #=> 20.00 (dollars)

job = Job.new(:edge, :wax)   #=> multiple services
job.duration                 #=> 2400 (seconds)
job.price                    #=> 53.33 (dollars)

job = Job.new(:performance)  #=> a package
job.duration                 #=> 4320 (seconds)
job.price                    #=> 96.00 (dollars)

job = Job.new(:basic, :ptex) #=> package + additional service
job.duration                 #=> 3600 (seconds)
job.price                    #=> 80.00 (dollars)
```

The calendar should be able to calculate the pickup times:

```ruby
job = Job.new(:performance)
calendar.pickup_time(job, dropoff_time: "Jun 6, 2016  9:10 AM") # => Mon Jun 06 10:22:00 2016
calendar.pickup_time(job, dropoff_time: "Jun 6, 2016  2:10 PM") # => Wed Jun 08 09:22:00 2016
calendar.pickup_time(job, dropoff_time: "Sep 3, 2016 12:10 PM") # => Wed Sep 07 09:22:00 2016
```

In the first example the job duration is 72 minutes. Since the 72 minutes fall within business hours, the customer can pick up their equipment the same day.

In the second example, the drop off time is 50 minutes before closing time which leaves 22 minutes remaining to be added to the next business day. The next day is Tuesday and therefore closed, so the resulting time is 22 minutes after opening on the following day.

The last example is the Saturday before the Labor Day holiday and Steezy's is only open until 1pm that day. They are closed the next three days (Sunday, Monday for the holiday, and Tuesday) therefore the pickup is not until 22 minutes after opening on Wednesday September 7th.

<hr>

## Instructions

* Download [the zip](https://github.com/printreleaf/kata/archive/master.zip) of this repository.
* There are skeleton test and implementation files to help get you started.
* Use RSpec for your tests. Run `$ rspec spec` to get started.
* Commit frequently and atomically.
* This should be a pure Ruby program, using only the Ruby standard libraries (no external gems or libraries).
* You do not need to build a gem for this, pure Ruby code is all that is needed.

**Tip:** Use `Time.parse` to generate a `Time` from a string. You may need to `require 'time'` in order to do this.

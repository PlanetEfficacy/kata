class Calendar
  attr_reader :opens_at,
              :closes_at
  def open(open, close)
    @opens_at = Time.parse(open)
    @closes_at = Time.parse(close)
  end
end

class Range
  def overlaps?(other)
    (self.first <= other.last) and (other.first <= self.last)
  end
end
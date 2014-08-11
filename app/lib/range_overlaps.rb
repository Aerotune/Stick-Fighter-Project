class Range
  def overlaps? range
    (first <= range.last) && (range.first <= last)
  end
end
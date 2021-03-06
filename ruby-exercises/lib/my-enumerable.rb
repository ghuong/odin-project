module Enumerable
  def my_each
    for i in (0...self.size)
      yield(self[i])
    end
    self
  end

  def my_each_with_index
    for i in (0...self.size)
      yield(self[i], i)
    end
    self
  end

  def my_select
    result = []
    self.my_each do |element|
      result << element if yield(element)
    end
    result
  end

  def my_all?
    self.my_each do |element|
      if not yield(element) then return false end
    end
    true
  end

  def my_any?
    self.my_each do |element|
      if yield(element) then return true end
    end
    false
  end

  def my_none?
    if not block_given? then return false end

    self.my_each do |element|
      if yield(element) then return false end
    end
    true
  end

  def my_count
    if not block_given? then return self.size end
    count = 0
    self.my_each do |element|
      count += 1 if yield(element)
    end
    count
  end

  def my_map(proc = nil)
    result = []
    self.my_each do |element|
      if not block_given?
        result << proc.call(element)
      else
        result << yield(element)
      end
    end
    result
  end

  def my_inject(default_accumulator = nil)
    result = default_accumulator || self[0]
    self.my_each do |element|
      result = yield(result, element)
    end
    result
  end
end

def multiply_els(array)
  array.my_inject(1) {|accum, elem| accum * elem}
end

def bubble_sort(array)
  bubble_sort_by(array) {|left, right| left - right}
end

def bubble_sort_by(array)
  array.length.times do |i|
    (0..array.length-2-i).each do |start|
      if yield(array[start], array[start+1]) > 0
        array[start], array[start+1] = array[start+1], array[start]
      end
    end
  end
  array
end
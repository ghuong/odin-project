def flatten(arr, result = [])
  arr.each do |element|
    if element.is_a? Array
      flatten(element, result)
    else
      result << element
    end
  end
  result
end
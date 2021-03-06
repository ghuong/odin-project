def merge_sort(arr)
  if arr.length <= 1
    arr
  else
    merge(merge_sort(arr[0...arr.length/2]), merge_sort(arr[arr.length/2..-1]))
  end
end

# merge two sorted arrays
def merge(arr1, arr2)
  result = []
  ptr1, ptr2 = 0, 0
  until ptr1 == arr1.length or ptr2 == arr2.length
    if arr1[ptr1] <= arr2[ptr2]
      result << arr1[ptr1]
      ptr1 += 1
    else
      result << arr2[ptr2]
      ptr2 += 1
    end
  end

  result = result + arr1[ptr1...arr1.length] + arr2[ptr2...arr2.length]
end
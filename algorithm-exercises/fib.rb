def fibs(n)
  fibs = []
  n.times do |i|
    case i
    when 0, 1
      fibs << i
    else
      fibs << fibs[-1] + fibs[-2]
    end
  end
  fibs
end

def fibs_rec(n)
  if n <= 2 then return [0, 1].first(n) end
  n_1 = fibs_rec(n - 1)
  n_1 << n_1[-1] + n_1[-2]
end
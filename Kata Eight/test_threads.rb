t1 = Thread.new do
  i = 0
  100_000_000.times do
    i += 1
  end
end
t2 = Thread.new do
  j = 0
  100_000_000.times do
    j += 1
  end
end
t1.join
t2.join
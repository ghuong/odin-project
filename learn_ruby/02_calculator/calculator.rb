def add(a, b)
	a + b
end

def subtract(a, b)
	a - b
end

def sum(numbers)
	result = 0
	numbers.each { |number| result += number }
	result
end

def multiply(*args)
	result = 1
	args.each { |x| result *= x }
	result
end

def power(base, exp)
	base**exp
end

def factorial(base)
	result = 1
	for i in 2..base
		result *= i
	end
	result
end
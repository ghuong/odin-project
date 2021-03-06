class StringCalculator
  def self.add(input)
    if input.empty?
      0
    else
      numbers = input.split(",").map { |num| num.to_i }
      numbers.reduce(0) { |sum, num| sum + num }
    end
  end
end
ROMAN_MAPPING = {
  1000 => "M",
  900 => "CM",
  500 => "D",
  400 => "CD",
  100 => "C",
  90 => "XC",
  50 => "L",
  40 => "XL",
  10 => "X",
  9 => "IX",
  5 => "V",
  4 => "IV",
  1 => "I",
  0 => "O"
}

def integer_to_roman(integer)
  if ROMAN_MAPPING.has_key? integer
    ROMAN_MAPPING[integer]
  else
    highest_denomination = ROMAN_MAPPING.keys.select { |key| key < integer }.max
    ROMAN_MAPPING[highest_denomination] + integer_to_roman(integer - highest_denomination)
  end
end

def roman_to_integer(roman, inverse_mapping = ROMAN_MAPPING.invert)
  if roman.length == 0
    0
  elsif roman.length == 1
    inverse_mapping[roman]
  elsif inverse_mapping.has_key? roman[0..1]
    inverse_mapping[roman[0..1]] + roman_to_integer(roman[2..-1], inverse_mapping)
  elsif inverse_mapping.has_key? roman[0]
    inverse_mapping[roman[0]] + roman_to_integer(roman[1..-1], inverse_mapping)
  else
    roman_to_integer(roman[1..-1], inverse_mapping)
  end
end
alphabet = ('а'..'я').to_a
vowel_letters = %w[а е и  о у э ю я]
hash = {}

vowel_letters.each do |letter|
  hash[letter] = alphabet.index(letter) + 1
end

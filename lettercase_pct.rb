def letter_percentages2(string)
  hash = {}
  hash[:lowercase] = ((string.count("/[a-z]/") / string.size.to_f) * 100)
  hash[:uppercase] = ((string.count("/[A-Z]/") / string.size.to_f) * 100)
  hash[:neither] = 100 - hash[:lowercase] - hash[:uppercase]
  p hash
end

def letter_percentages(string)
  hash = {}
  hash[:lowercase] = ((string.scan(/[a-z]/).size / string.size.to_f) * 100)
  hash[:uppercase] = ((string.scan(/[A-Z]/).size / string.size.to_f) * 100)
  hash[:neither] = ((string.scan(/[^A-Za-z]/).size / string.size.to_f) * 100)
  p hash
end




p letter_percentages('abCdef 123') == { lowercase: 50, uppercase: 10, neither: 40 }
p letter_percentages('AbCd +Ef') == { lowercase: 37.5, uppercase: 37.5, neither: 25 }
p letter_percentages('123') == { lowercase: 0, uppercase: 0, neither: 100 }
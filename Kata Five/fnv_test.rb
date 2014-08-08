require '.\digestfnv'
# puts Digest::FNV.hexdigest("abc123")
puts Digest::FNV.calculate("abc123", 1024)
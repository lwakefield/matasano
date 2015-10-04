#!/usr/bin/ruby

def decode_hex(hex_digest)
    return [hex_digest.strip].pack('H*')
end

def xor_hex(hex_digest, key)
    return sprintf('%x', hex_digest.hex ^ key.hex)
end

def score(plaintext)
    alpha_count = plaintext.scan(/[a-z]/i).size
    score =  plaintext.scan(/[eaton shrldu]/i).size
    return (alpha_count * score).to_f / plaintext.length
end

key = ARGV[0]
input = ''
while i = STDIN.gets
    input += i
end

input = input.strip
repeated_key = key * (input.length.to_f / key.length).ceil
repeated_key = repeated_key.chars.first(input.length).join
raise "input should be the same length as the key" unless repeated_key.length == input.length

puts input.bytes.zip(repeated_key.bytes).map{ |a,b| sprintf("%02x", (a ^ b)) }.join

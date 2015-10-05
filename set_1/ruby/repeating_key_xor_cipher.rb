#!/usr/bin/ruby

require_relative 'crypto'

def decode_hex(hex_digest)
    return [hex_digest.strip].pack('H*')
end

def xor_hex(hex_digest, key)
    return sprintf('%x', hex_digest.hex ^ key.hex)
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

puts Crypto.xor_strings(input, repeated_key)

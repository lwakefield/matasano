#!/usr/bin/ruby

require_relative 'crypto'

key = ARGV[0]
input = ''
while i = STDIN.gets
    input += i
end
input = input.strip

repeated_key = Crypto.make_repeating_key(key, input.length)
puts Crypto.xor_raw_strings(input, repeated_key)

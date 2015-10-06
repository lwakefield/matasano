#!/usr/bin/ruby

require_relative 'crypto'
require_relative 'util'

key = ARGV[0]
input = ''
while i = STDIN.gets
    input += i
end
input = input.strip

cipher_text = Datum.make_from_string input
repeated_key = Util.make_repeating_key key, cipher_text.length

puts Crypto.xor(cipher_text, repeated_key).to_hex

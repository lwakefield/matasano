#!/usr/bin/ruby

require_relative 'crypto'

while a = gets
    inputs = a.split('^')
    puts Crypto.xor_hex_strings(inputs[0], inputs[1])
end


#!/usr/bin/ruby

require_relative 'crypto'
require_relative 'datum'

while a = gets
    inputs = a.split('^')
    a = Datum.make_from_hex inputs[0]
    b = Datum.make_from_hex inputs[1]
    xored = Crypto.xor a, b
    puts xored
end


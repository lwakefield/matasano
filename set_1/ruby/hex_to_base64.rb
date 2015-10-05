#!/usr/bin/ruby

require_relative 'crypto'

while a = gets
    puts Crypto.encode_base64(Crypto.decode_hex(a))
end

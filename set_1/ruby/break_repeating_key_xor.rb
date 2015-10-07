#!/usr/bin/ruby

require_relative 'crypto'
require_relative 'datum'
require 'matrix'

input = ''
while i = STDIN.gets
    input += i.strip
end

cipher_text = Datum.make_from_base64 input
plaintext, key = Crypto.break_repeating_key_xor cipher_text, 100
printf "Key(%d):\n%s\n", key.length, key
printf "=" * 32 + "\n"
printf "Plaintext:\n%s\n", plaintext

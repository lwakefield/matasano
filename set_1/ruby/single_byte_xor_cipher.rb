#!/usr/bin/ruby

require_relative 'crypto'
require_relative 'datum'

top_score = 0
top_soln = ''
while input = gets
    cipher_text = Datum.make_from_hex input
    (0..255).each do |i|
        key = Datum.make_from_bytes [i]*cipher_text.length
        xored = Crypto.xor cipher_text, key
        score = Crypto.score_english(xored)
        if score > top_score
            top_score = score
            top_soln = xored
        end
    end
end
printf("%f: %s\n", top_score, top_soln)

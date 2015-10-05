#!/usr/bin/ruby

require_relative 'crypto'

top_score = 0
top_soln = ''
while hex_digest = gets
    (0..255).each do |i|
        key = Crypto.byte_to_hex_string(i) * (hex_digest.length / 2)
        xored = Crypto.xor_hex_strings(hex_digest, key)
        plaintext = Crypto.decode_hex(xored)
        score = Crypto.score_english(plaintext)
        if score > top_score
            top_score = score
            top_soln = plaintext
        end
    end
end
printf("%f: %s\n", top_score, top_soln)

#!/usr/bin/ruby

require 'facets'

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

top_score = 0
top_soln = ''
while hex_digest = gets
    (0..255).each do |i|
        key = i.to_s(16) * (hex_digest.length / 2)
        xored = xor_hex(hex_digest, key)
        plaintext = decode_hex(xored)
        score = score(plaintext)
        if score > top_score
            top_score = score
            top_soln = plaintext
        end
    end
end
printf("%f: %s\n", top_score, top_soln)
